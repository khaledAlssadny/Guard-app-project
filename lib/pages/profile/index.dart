/*
ana fe al directory aly asmha "Pages" 7att files kteer zay "state" wa "view" wa kda
fa badl ma kol mara hast3ml file mnhom hafdl a3ml imports la kol wa7ed one by one
la2 ala7san 2n a3ml library hasmeha welcome wa mograd ma anady 3alaha hat3ml call la kol al files
*/
library profile;

export './state.dart';
export './bindings.dart';
export './controller.dart';
export './view.dart';

/*
When a Dart file imports welcome.dart, it can access all the exported members of the state.dart, bindings.dart, controller.dart, and view.dart files.

state.dart typically contains the state management for a Flutter widget. It defines a class that extends GetxController (from the get package), which allows for reactive state management in Flutter.

bindings.dart typically contains the bindings for the state and dependencies of a widget. It defines a class that extends Bindings (from the get package), which allows for dependency injection in Flutter.

controller.dart typically contains the business logic for a widget. It defines a class that extends GetxController (from the get package), which allows for reactive state management in Flutter.

view.dart typically contains the user interface (UI) code for a widget. It defines a widget class that extends GetView (from the get package), which allows for reactive state management and dependency injection in Flutter.

By exporting these four files from welcome.dart, the code that imports welcome.dart can access all the state, bindings, controller, and view logic for the Welcome widget without having to import each file separately. This helps to simplify the import process and make the code more organized.
 */