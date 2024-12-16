double calculerPourcentageAge(int minAge, int maxAge) {
  // Table des pourcentages pour chaque intervalle d'âge
  final List<Map<String, dynamic>> intervals = [
    {'min': 18, 'max': 24, 'percent': 0.09}, 
    {'min': 25, 'max': 29, 'percent': 0.055},
    {'min': 30, 'max': 34, 'percent': 0.059},
    {'min': 35, 'max': 39, 'percent': 0.062},
    {'min': 40, 'max': 44, 'percent': 0.063},
    {'min': 45, 'max': 49, 'percent': 0.06},
    {'min': 50, 'max': 54, 'percent': 0.067},
    {'min': 55, 'max': 59, 'percent': 0.065},
    {'min': 60, 'max': 64, 'percent': 0.062},
    {'min': 65, 'max': 69, 'percent': 0.057},
    {'min': 70, 'max': 74, 'percent': 0.054},
    {'min': 75, 'max': 80, 'percent': 0.052},
  ];

  double totalPercentage = 0.0;

  for (var interval in intervals) {
    int intervalMin = interval['min'];
    int intervalMax = interval['max'];
    double intervalPercent = interval['percent'];

    // Trouver l'intersection entre [minAge, maxAge] et l'intervalle courant
    int overlapMin = intervalMin > minAge ? intervalMin : minAge;
    int overlapMax = intervalMax < maxAge ? intervalMax : maxAge;

    if (overlapMin <= overlapMax) {
      // Proportion de chevauchement de l'intervalle
      double proportion = (overlapMax - overlapMin + 1) /
          (intervalMax - intervalMin + 1);
      totalPercentage += proportion * intervalPercent;
    }
  }

  return totalPercentage.clamp(0.0, 1.0); // Retourne un pourcentage entre 0.0 et 1.0
}






double calculerPourcentageFinal({
  required String gender, // "homme" ou "femme"
  required int minAge, // Âge minimum
  required int maxAge, // Âge maximum
  required String region, // Âge maximum
  required double height, // Taille parfaite en cm
  int? minIncome, // Optionnel 
}) {
  // Définir les pourcentages de base en fonction des critères

  double pourcentageGender;
  if (genre.toLowerCase() == "homme") {
    pourcentageGender = 0.484; 
  } else if (genre.toLowerCase() == "femme") {
    pourcentageGender = 0.516; 
  } else {
    throw ArgumentError("Genre invalide. Utilisez 'homme' ou 'femme'.");
  }


  double pourcentageAge = calculerPourcentageAge(minAge, maxAge); 


  double pourcentageHeight;
  if (height < 150) {
    percentageHeight = 5; 
  } else if (height >= 150 && height < 165) {
    percentageHeight = 10;  
  } else if (height >= 165 && height < 185) {
    percentageHeight = 70;  
  } else if (height >= 185 && height < 200) {
    percentageHeight = 10;  
  } else {
    percentageHeight = 5;  
  }


  double pourcentageRegion; 
  if (region.toLowerCase() == "sud") {
    pourcentageRegion = 0.27; 
  } else if (region.toLowerCase() == "nord") {
    pourcentageRegion = 0.33; 
  } else if (region.toLowerCase() == "est") {
    pourcentageRegion = 0.15; 
  } else if (region.toLowerCase() == "ouest") {
    pourcentageRegion = 0.21; 
  } else if (region.toLowerCase() == "outremer") {
    pourcentageRegion = 0.06; 
  } else {
    throw ArgumentError("Région invalide");
  }


  double pourcentageIncome;
  if (minIncome <= 12970) {
    pourcentageIncome = 0.9; 
  } else if (minIncome > 12970 && minIncome <= 24330) {
    pourcentageIncome = 0.8;  
  } else if (minIncome > 24330 && minIncome <= 43840) {
    pourcentageIncome = 0.5;  
  } else if (minIncome > 43840 && minIncome <= 54620) {
    pourcentageIncome = 0.15;  
  } else {
    pourcentageIncome = 0.05;  
  }

  // Calculer le pourcentage final
  double resultat = pourcentageGender *
      pourcentageAge *
      pourcentageHeight *
      pourcentageRegion *
      pourcentageIncome;


  return resultat.clamp(0.0, 1.0) * 100; // Conversion en pourcentage (0-100)
}
