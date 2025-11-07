# frozen_string_literal: true

require 'json'

HISTORIQUE_PATH = 'historique.json'

def charger_historique
  unless File.exist?(HISTORIQUE_PATH)
    historique_initial = { 'grilles' => [], 'totaux' => { 'nombre_1' => 0, 'nombre_N' => 0,
                                                          'nombre_2' => 0, 'cons_1' => 0,
                                                          'cons_N' => 0, 'cons_2' => 0,
                                                          'diagonales' => 0, 'symetries' => 0,
                                                          'alternances' => 0, 'paires' => 0,
                                                          'tierces' => 0, 'quarts' => 0 } }

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
  puts '3. Quitter'
  print 'Votre choix: '
end

def boucle_principale(_historique)
  loop do
    afficher_menu
    choix = gets.chomp

    case choix
    when '1'
      puts "\n[INFO] Fonction pas encore implémentée. La grille du jour sera affichée ici."
    when "2"
      print "\nEntrez la grille (ex: 1-2-1-N-1-2-2): "
      saisie = gets.chomp
      g = normaliser_grille(saisie)
      stats = calculer_stats(g)
      puts "\nStatistiques calculées:"
      puts stats
    when '3'
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
