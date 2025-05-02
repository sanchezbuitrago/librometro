import 'dart:math';

class IDGenerator {
  static String getId({int size = 10}){
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(size, (index) => characters[random.nextInt(characters.length)]).join();
  }
}