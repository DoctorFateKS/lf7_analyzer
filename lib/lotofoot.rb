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
historique = charger_historique
puts 'Historique chargé avec succès.'
puts "Il contient #{historique['grilles'].size} grille(s)."
