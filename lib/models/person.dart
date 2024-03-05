import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class Person extends Equatable {
  final String name;
  final int age;
  final String uuid;

  Person({required this.name, required this.age, String? uuid})
      : uuid = uuid ?? const Uuid().v4();

  Person updated({String? name, int? age}) =>
      Person(name: name ?? this.name, age: age ?? this.age);

  String get displayName => '$name ($age years old)';

  @override
  // TODO: implement props
  List<Object?> get props => [uuid];

  @override
  bool get stringify => true;
}

class PersonsNotifier extends Notifier<List<Person>> {
  @override
  List<Person> build() {
    // TODO: implement build
    return [];
  }

  // int get count => state.length;
  void addPerson(Person person) {
    state = [...state, person];
  }

  void removePerson(String personId) {
    state = [
      for (final person in state)
        if (person.uuid != personId) person,
    ];
  }

  void updatePerson(Person updatedPerson) {
    final index = state.indexOf(updatedPerson);
    final oldPerson = state[index];
    if (oldPerson.name != updatedPerson.name ||
        oldPerson.age != updatedPerson.age) {
      state[index] =
          oldPerson.updated(name: updatedPerson.name, age: updatedPerson.age);
    }
  }
}

final personProvider = NotifierProvider<PersonsNotifier, List<Person>>(() {
  return PersonsNotifier();
});
