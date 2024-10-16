// Base class (superclass)
// ignore_for_file: avoid_print

abstract class Animal {
  final String species;
  final String name;

  Animal(this.species, this.name);

  void makeSound();

  @override
  String toString() => '$name is a $species';
}

// Subclass
class Dog extends Animal {
  Dog(String name, String species) : super(species, name);

  @override
  void makeSound() {
    print('$name barks: Woof! Woof!');
  }
}

// Another subclass
class Cat extends Animal {
  Cat(String name) : super('Felis catus', name);

  @override
  void makeSound() {
    print('$name meows: Meow!');
  }
}

// Usage
void main() {
  final buddy = Dog('Buddy', "Canis familiaris");
  final whiskers = Cat('Whiskers');

  print(buddy.species); // Output: Buddy is a Canis familiaris
  buddy.makeSound(); // Output: Buddy barks: Woof! Woof!

  print(whiskers); // Output: Whiskers is a Felis catus
  whiskers.makeSound(); // Output: Whiskers meows: Meow!
}
