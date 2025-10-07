# primera_app_noms

# A new Flutter project.

Aplicació desenvolupada amb **Flutter** que genera noms catalans de forma aleatòria i permet desar-los com a favorits.  
El projecte inclou **mode clar/fosc**, persistència local amb **SharedPreferences**, i una **animació Lottie** que apareix quan la llista de favorits està buida.  
Tot amb un enfocament **DRY (Don’t Repeat Yourself)** i un disseny coherent entre pantalles.

> > > > > > > 667c81e (Update README.md)

## Getting Started

This project is a starting point for a Flutter application.

# A few resources to get you started if this is your first Flutter project:

✅ Generació infinita de noms catalans amb el paquet [`random_name_generator`](https://pub.dev/packages/random_name_generator)  
✅ Filtratge per gènere: **Tots, Dona o Home**  
✅ Sistema de favorits amb desat local (**SharedPreferences**)  
✅ Mode clar i mode fosc amb canvi instantani des de la barra superior  
✅ **Animació Lottie** quan la llista de favorits està buida (`motion.json`)  
✅ Eliminació individual de favorits des de la pàgina dedicada  
✅ Disseny **responsive i net**, amb tipografies **Bebas Neue** i **Poppins** via Google Fonts

> > > > > > > 667c81e (Update README.md)

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======

---

## 🧠 Estructura principal de fitxers

lib/
├── main.dart # Punt d’entrada de l’app
├── people_list.dart # Pantalla principal amb generador i filtres
├── favorites_page.dart # Pantalla de favorits amb animació Lottie
├── person_detail.dart # Vista detall d’un nom
assets/
└── animations/motion.json # Animació mostrada quan no hi ha favorits

---

## 🧩 Requeriments tècnics

- Flutter SDK **≥ 3.9.0**
- Dependències:
  - `random_name_generator`
  - `shared_preferences`
  - `google_fonts`
  - `lottie`

---

## 💬 Desenvolupament

Projecte creat per **Anna Borràs Font** com a part del curs  
📚 _Desenvolupament d'aplicacions mòbils per a iOS i Android amb Flutter (CIFO, 2025)_

✨ _“El millor codi és el que és simple, elegant i fàcil d’entendre.”_

> > > > > > > 667c81e (Update README.md)
