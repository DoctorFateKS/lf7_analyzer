# frozen_string_literal: true

require 'json'

HISTORIQUE_PATH = 'historique.json'

def structure_totaux_initiale
  {
    "nombre_1" => Hash[(0..7).map { |n| [n.to_s, 0] }],
    "nombre_N" => Hash[(0..7).map { |n| [n.to_s, 0] }],
    "nombre_2" => Hash[(0..7).map { |n| [n.to_s, 0] }],

    "cons_1" => Hash[(0..7).map { |n| [n.to_s, 0] }],
    "cons_N" => Hash[(0..7).map { |n| [n.to_s, 0] }],
    "cons_2" => Hash[(0..7).map { |n| [n.to_s, 0] }],

    "diagonales" => Hash[(0..5).map { |n| [n.to_s, 0] }],
    "symetries" => Hash[(0..3).map { |n| [n.to_s, 0] }],
    "alternances" => Hash[(0..6).map { |n| [n.to_s, 0] }],

    "paires"  => Hash[(1..6).map { |n| [n.to_s, 0] }],
    "tierces" => Hash[(1..5).map { |n| [n.to_s, 0] }],
    "quarts"  => Hash[(1..4).map { |n| [n.to_s, 0] }],

    "mise_totale" => 0,
    "gain_total" => 0,
    "profit_total" => 0
  }
end

def charger_historique
  unless File.exist?(HISTORIQUE_PATH)
    historique_initial = {
      "grilles" => [],
      "totaux" => structure_totaux_initiale
    }

    File.write(HISTORIQUE_PATH, JSON.pretty_generate(historique_initial))
  end

  JSON.parse(File.read(HISTORIQUE_PATH))
end

def sauvegarder_historique(historique)
  File.write(HISTORIQUE_PATH, JSON.pretty_generate(historique))
end

# Programme principal
def normaliser_grille(chaine)
  chaine.tr("-", " ").split.map(&:upcase)
end

def compter_consecutifs(grille, signe)
  max = 0
  actuel = 0

  grille.each do |s|
    if s == signe
      actuel += 1
      max = [max, actuel].max
    else
      actuel = 0
    end
  end

  max
end

def compter_diagonales(grille)
  motifs = [
    ["1", "N", "2"],
    ["2", "N", "1"]
  ]
  count = 0

  (0..grille.size - 3).each do |i|
    triplet = grille[i, 3]
    count += 1 if motifs.include?(triplet)
  end

  count
end

def compter_symetries(grille)
  count = 0
  left = 0
  right = grille.size - 1

  while left < right
    count += 1 if grille[left] == grille[right]
    left += 1
    right -= 1
  end

  count
end

def compter_alternances(grille)
  count = 0
  (0..grille.size - 2).each do |i|
    count += 1 if grille[i] != grille[i + 1]
  end
  count
end

def compter_series(grille, longueur)
  series = []
  (0..grille.size - longueur).each do |i|
    series << grille[i, longueur].join
  end
  series.uniq.size
end

def calculer_stats(grille)
  {
    "nombre_1" => grille.count("1"),
    "nombre_N" => grille.count("N"),
    "nombre_2" => grille.count("2"),

    "cons_1" => compter_consecutifs(grille, "1"),
    "cons_N" => compter_consecutifs(grille, "N"),
    "cons_2" => compter_consecutifs(grille, "2"),

    "diagonales" => compter_diagonales(grille),
    "symetries" => compter_symetries(grille),
    "alternances" => compter_alternances(grille),

    "paires"  => compter_series(grille, 2),
    "tierces" => compter_series(grille, 3),
    "quarts"  => compter_series(grille, 4)
  }
end

def afficher_menu
  puts "\n===== LOTOFOOT 7 ====="
  puts '1. Afficher la grille du jour'
  puts '2. Ajouter une nouvelle grille terminée'
  puts '3. Afficher les statistiques cumulés'
  puts '4. Quitter'
  print 'Votre choix: '
end

def ajouter_grille(historique)
  print "\nEntrez la date de la grille (ex: 2025-01-12) : "
  date = gets.chomp

  print "Entrez la grille (ex: 1-2-1-N-1-2-2) : "
  saisie = gets.chomp

  print "Montant misé sur cette grille (€) : "
  mise = gets.chomp.to_f

  print "Montant gagné sur cette grille (€) : "
  gain = gets.chomp.to_f

  profit = gain - mise

  grille = normaliser_grille(saisie)
  stats = calculer_stats(grille)

  # Ajout de la grille complète dans l'historique
  historique["grilles"] << {
    "date" => date,
    "grille" => grille,
    "stats" => stats,
    "mise" => mise,
    "gain" => gain,
    "profit" => profit
  }

  # Mise à jour des histogrammes statistiques
  stats.each do |cle, valeur|
    valeur_str = valeur.to_s
    historique["totaux"][cle][valeur_str] ||= 0
    historique["totaux"][cle][valeur_str] += 1
  end

  # Mise à jour des totaux financiers
  historique["totaux"]["mise_totale"]  ||= 0
  historique["totaux"]["gain_total"]   ||= 0
  historique["totaux"]["profit_total"] ||= 0

  historique["totaux"]["mise_totale"]  += mise
  historique["totaux"]["gain_total"]   += gain
  historique["totaux"]["profit_total"] += profit

  sauvegarder_historique(historique)

  puts "\n✅ Grille enregistrée avec succès."
  puts "Profit net : #{profit} €"
end

def generer_toutes_les_grilles
  signes = ["1", "N", "2"]
  combinaisons = signes.repeated_permutation(7).to_a
  combinaisons
end

def generer_grilles_avec_stats
  generer_toutes_les_grilles.map do |grille|
    {
      "grille" => grille,
      "stats" => calculer_stats(grille)
    }
  end
end

def score_grille(stats, totaux)
  score = 0

  stats.each do |cle, valeur|
    valeur_str = valeur.to_s
    histogramme = totaux[cle]

    if histogramme && histogramme[valeur_str]
      score += histogramme[valeur_str]
    end
  end

  score
end

def meilleures_grilles_du_jour(historique)
  totaux = historique["totaux"]
  grilles = generer_grilles_avec_stats

  scores = grilles.map do |g|
    s = score_grille(g["stats"], totaux)
    { "grille" => g["grille"], "stats" => g["stats"], "score" => s }
  end

  max_score = scores.map { |g| g["score"] }.max

  meilleures = scores.select { |g| g["score"] == max_score }

  { "score" => max_score, "grilles" => meilleures }
end

def afficher_totaux(historique)
  puts "\n===== STATISTIQUES HISTORIQUES =====\n\n"

  # Parcours des statistiques (hash de valeurs)
  historique["totaux"].each do |critere, histo|
    next if ["mise_totale", "gain_total", "profit_total"].include?(critere)  # ignorer les chiffres

    puts "#{critere}:"
    histo.each do |val, nb|
      puts "  valeur #{val}: #{nb} fois"
    end
    puts ""
  end

  # Affichage finances
  puts "===== FINANCES ====="
  puts "Mises totales : #{historique["totaux"]["mise_totale"]} €"
  puts "Gains totaux : #{historique["totaux"]["gain_total"]} €"
  profit = historique["totaux"]["profit_total"]
  puts "Profit total : #{profit} €"

  if historique["totaux"]["mise_totale"] > 0
    roi = (profit / historique["totaux"]["mise_totale"]) * 100
    puts "ROI : #{roi.round(2)} %"
  end
end

def boucle_principale(_historique)
  loop do
    afficher_menu
    choix = gets.chomp

    case choix
    when "1"
      puts "\nCalcul de la grille du jour..."
      resultat = meilleures_grilles_du_jour(_historique)
      score = resultat["score"]
      grilles = resultat["grilles"]

      puts "\n✅ Score maximal : #{score}"
      puts "✅ Nombre de grilles optimales : #{grilles.size}"

      grilles.first(30).each_with_index do |g, i|
        puts "\nOption #{i+1}: #{g["grille"].join("-")}"
      end

      if grilles.size > 30
        puts "\n...et #{grilles.size - 30} autres grilles"
      end
    when "2"
      ajouter_grille(_historique)
    when "3"
      afficher_totaux(_historique)
    when '4'
      puts "\nAu revoir."
      break
    else
      puts "\nChoix invalide."
    end
  end
end

# Programme principal
historique = charger_historique
puts 'Historique chargé avec succès.'
boucle_principale(historique)
