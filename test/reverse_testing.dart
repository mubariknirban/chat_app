import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main(){
  testWidgets('widgettest', (WidgetTester tester)async{
    await tester.pumpWidget(MyApp());
    var textfield = find.byType(TextField);
    expect(textfield, findsOneWidget);
    await tester.enterText(textfield, "Hello");
    var button = find.text('Reverse');
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pump();
    expect(find.text("olleH"), findsOneWidget);
  });
}