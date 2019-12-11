import 'package:hello/image.dart';

class Interpreter {

  static List<String> getInstructions(List<Brick> bricks) {
    return _itterateBricks(bricks);
  }

  static List<String> _itterateBricks(List<Brick> bricks) {
    List<String> commands = new List<String>();

    for (int i = 0; i < bricks.length; i++){
      print('Brick number: ' + i.toString() + ',');
      commands.addAll(_brickColorFilter(bricks[i]));
    }

    return commands;
  }

  static List<String> _brickColorFilter(Brick brick){
    switch (brick.color){
      case LegoColor.red:
        print('Color: Red,');
        print('X: ' + brick.width.toString() + ' Y: ' + brick.height.toString());
        return redBrickMono(brick.width, brick.height);
      case LegoColor.green:
        print('Color: Green,');
        print('X: ' + brick.width.toString() + ' Y: ' + brick.height.toString());
        return greenBrick(brick.width, brick.height);
      case LegoColor.blue:
        print('Color: Blue,');
        print('X: ' + brick.width.toString() + ' Y: ' + brick.height.toString());
        throw new Exception('No blue action implemented yet!');
      case LegoColor.yellow:
        print('Color: Yellow,');
        print('X: ' + brick.width.toString() + ' Y: ' + brick.height.toString());
        return yellowBrick(brick.width, brick.height);
      case LegoColor.light_green:
        print('Color: Light Green,');
        print('X: ' + brick.width.toString() + ' Y: ' + brick.height.toString());
        return greenBrick(brick.width, brick.height);
      case LegoColor.none:
        throw new Exception('No color assigned to detected brick!');
      default:
        throw new Exception('Unable to handle color ${brick.color}');
    }
  }

  static List<String> redBrick(int x, int y){

    List<String> returnList = new List<String>();
    String voiceCommand = "say pausing";

    //pause command
    String command = "pause";
    //seconds
    command += " " + (x*y).toString();

    returnList.add(voiceCommand);
    returnList.add(command);

    return returnList;
  }

  static List<String> redBrickMono(int x, int y){

    List<String> returnList = new List<String>();
    String voiceCommand;
    String command;

    if(x == 2 && y == 2){
      //voice command
      voiceCommand = "say moving forward";
      //move command
      command = "mov";
      //speed
      command += " " + "50";
      //distance
      command += " " + "500";
    }
    else if (x == 2 && y == 1){
      //voice command
      voiceCommand = "say rotating left";
      //rotate command
      command = "rot";
      //speed??
      command += " " + "50";
      //degrees???
      command += " " + "90";
    }
    else if (x == 1 && y == 2){
      //voice command
      voiceCommand = "say rotating right";
      //rotate command
      command = "rot";
      //speed??
      command += " " + "50";
      //degrees???
      command += " " + "-90";
    }
    else if (x == 1 && y == 1){
      //voice command
      voiceCommand = "say pause";
      //rotate command
      command = "pause";
      //seconds
      command += " " + "1";
    }

    returnList.add(voiceCommand);
    returnList.add(command);

    return returnList;
  }

  static List<String> yellowBrick(int x, int y){

    List<String> returnList = new List<String>();
    String voiceCommand = "say rotating";

    //rotate command
    String command = "rot";
    //speed??
    command += " " + "50";
    //degrees???
    command += " " + "90";

    returnList.add(voiceCommand);
    returnList.add(command);

    return returnList;
  }

  // voice feedback
  // mono color bricks
  // box enclosure
  // illicitation study (call it a design workshop)
  // take contact with blind people
  // bricklink
  // work out coding schemes using related works


  static List<String> greenBrick(int x, int y){

    List<String> returnList = new List<String>();
    String voiceCommand = "say moving";

    //move command
    String command = "mov";
    //seconds
    command += " " + "50";
    //speed
    command += " " + ((x*y)*10*2).toString();

    returnList.add(voiceCommand);
    returnList.add(command);

    return returnList;
  }
}