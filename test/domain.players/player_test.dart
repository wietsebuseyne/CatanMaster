import 'package:catan_master/domain/players/player.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {

  const Color _defaultColor = Color(0xFFF44336);

  setUp(() {

  });

  Player _createPlayer({
    String name = "name",
    String username = "username",
    Color color = _defaultColor,
    Gender gender = Gender.x,
  }) {
    return Player(
      name: name,
      username: username,
      color: color,
      gender: gender,
    );
  }

  group('constructor', () {

    test('basic equality', () {
      final Player p1 = Player(
        name: "name",
        username: "username",
        color: _defaultColor,
        gender: Gender.x,
      );

      expect(p1.color, equals(_defaultColor));
      expect(p1.gender, equals(Gender.x));
      expect(p1.name, equals("name"));
      expect(p1.username, equals("username"));
    });

    test('username is set to lowercase', () {
      final Player p1 = _createPlayer(username: "userName");

      expect(p1.username, equals("username"));
    });

  });

  group('equals()', () {

    group('equality', () {

      test('basic equality', () {
        final Player p1 = _createPlayer();
        final Player p1Copy = _createPlayer();

        expect(p1, equals(p1Copy));
      });

      test('username caps differences', () {
        final Player p1 = _createPlayer(username: "username");
        final Player p1Copy = _createPlayer(username: "userName");

        expect(p1, equals(p1Copy));
      });

      test('MaterialColor', () {
        final Player p1 = _createPlayer(color: Colors.red);
        final Player p2 = _createPlayer(color: Colors.red);

        expect(p1, equals(p2));
      });

      test('color contains MaterialColor with same value', () {
        final Player p1 = _createPlayer();
        final Player p2 = _createPlayer(color: Colors.red);

        expect(p1, equals(p2));
      });

    });

    group('non-equality', () {

      test('name', () {
        final Player p1 = _createPlayer(name: "abc");
        final Player p2 = _createPlayer(name: "def");

        expect(p1, isNot(equals(p2)));
      });

      test('username', () {
        final Player p1 = _createPlayer(username: "username");
        final Player p2 = _createPlayer(name: "def");

        expect(p1, isNot(equals(p2)));
      });

      test('gender', () {
        final Player p1 = _createPlayer();
        final Player p1Male = _createPlayer(gender: Gender.male);
        final Player p1Female = _createPlayer(gender: Gender.female);

        expect(p1, isNot(equals(p1Male)));
        expect(p1, isNot(equals(p1Female)));
      });

      test('color', () {
        final Player p1 = _createPlayer();
        final Player p2 = _createPlayer(color: Colors.white);

        expect(p1, isNot(equals(p2)));
      });

      test('MaterialColor with other value', () {
        final Player p1 = _createPlayer(color: Colors.red);
        final Player p2 = _createPlayer(color: Colors.orange);

        expect(p1, isNot(equals(p2)));
      });

    });

  });

}