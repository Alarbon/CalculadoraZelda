import 'package:audioplayers/audioplayers.dart';
import 'package:eval_ex/expression.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = '0';
  List<String> historial = [];
  AudioPlayer audioPlayer = AudioPlayer();
  bool esMovil = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Pantalla pequeña
              esMovil = true;
              return calculadora(esMovil);
            } else {
              // Pantalla grande
              esMovil = false;
              return calculadoraWeb(esMovil);
            }
          },
        ),
      ),
    );
  }

  Widget calculadoraWeb(bool esMovil) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          calculadora(esMovil),
          historialCalculadora(),
        ],
      ),
    );
  }

  Widget calculadora(bool esMovil) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      screenWidth = 600;
    }
    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth,
      ),
      child: Column(
        children: [
          _imagenHeader(esMovil),
          _cajaTexto(esMovil),
          _imagenLogo(esMovil),
          _botones(esMovil),
        ],
      ),
    );
  }

  Widget historialCalculadora() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth > 870
        ? Container(
            width: screenWidth * 0.3,
            height: screenHeight * 0.8,
            decoration:  BoxDecoration(
              color: Colors.white70,
              borderRadius: const BorderRadius.all(
                Radius.circular(15),),
              boxShadow: [
                BoxShadow(
                  blurRadius: 100,
                  color: Colors.yellow[800]!,
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: historial.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          historial[index],
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.02),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _cajaTexto(bool esMovil) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenWidth * 0.24,
      constraints: const BoxConstraints(
        maxHeight: 150,
      ),
      alignment: Alignment.bottomRight,
      color: Colors.white70,
      child: SingleChildScrollView(
        reverse: true,
        scrollDirection: Axis.horizontal,
        child: Text(
          result,
          style: TextStyle(
              fontSize: _alturaCajaResultado(screenWidth, result, esMovil),
              color: Colors.black),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _imagenHeader(bool esMovil) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.10,
      child: Center(
        child: Image(
          image: const AssetImage('assets/images/vida.webp'),
          width: screenHeight * 0.15,
        ),
      ),
    );
  }

  Widget _imagenLogo(bool esMovil) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.15,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: const AssetImage('assets/images/escudo.webp'),
                width: screenHeight * 0.08,
              ),
              Image(
                image: const AssetImage('assets/images/Trifuerza.webp'),
                width: screenHeight * 0.2,
              ),
              Image(
                image: const AssetImage('assets/images/espada.webp'),
                width: screenHeight * 0.08,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botones(bool esMovil) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            _filaDeBotones(['DEL', '(', ')', '/'], esMovil),
            _filaDeBotones(['7', '8', '9', 'x'], esMovil),
            _filaDeBotones(['4', '5', '6', '-'], esMovil),
            _filaDeBotones(['1', '2', '3', '+'], esMovil),
            _filaDeBotones(['.', '0', 'C', '='], esMovil),
          ],
        ),
      ),
    );
  }

  Widget _filaDeBotones(List<String> textos, bool esMovil) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: textos.map((texto) => _boton(texto, esMovil)).toList(),
    );
  }

  Widget _boton(String texto, bool esMovil) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      screenWidth = 600;
    }
    double buttonWidth = screenWidth * 0.20;
    double buttonHeight = screenHeight * 0.09;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white70,
          backgroundColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          minimumSize: Size(buttonWidth, buttonHeight),
          maximumSize: Size(buttonWidth * 1, buttonHeight * 1.1),
        ),
        onPressed: () async {
          if (result == '467467') {
            await _reproducirSonido(result);
            result = '0';
          } else {
            await _reproducirSonido(texto);
          }
          setState(() {
            if (texto == 'C') {
              result = '0';
            } else if (texto == 'DEL') {
              result = result.substring(0, result.length - 1);
              if (result == '') {
                result = '0';
              }
            } else if (texto == '=') {
              result = _calcularResultado();
            } else {
              if (result == '0' || result == 'Error' || result == '467467') {
                result = texto;
              } else {
                result += texto;
              }
            }
          });
        },
        child: _tipoBoton(texto, esMovil),
      ),
    );
  }

  Future<void> _reproducirSonido(String texto) async {
    Map<String, String> rutasSonidos = {
      '0': 'songs/re.wav',
      '1': 'songs/do.wav',
      '2': 'songs/re.wav',
      '3': 'songs/mi.wav',
      '4': 'songs/fa.wav',
      '5': 'songs/sol.wav',
      '6': 'songs/la.wav',
      '7': 'songs/si.wav',
      '8': 'songs/re.wav',
      '9': 'songs/mi.wav',
      '467467': 'songs/sariaSong.mp3'
    };
    try {
      await audioPlayer.play(AssetSource(rutasSonidos[texto]!));
      // ignore: empty_catches
    } catch (error) {}
  }

  Widget _tipoBoton(String texto, bool esMovil) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 600) {
      screenWidth = 600;
    }
    // Ajustar tamaños proporcionales
    double fontSize = esMovil ? screenWidth * 0.065 : screenWidth * 0.065;
    double iconSize = esMovil ? screenWidth * 0.065 : screenWidth * 0.065;

    Map<String, Widget> botones = {
      '7': _textoBoton('7', fontSize),
      '8': _textoBoton('8', fontSize),
      '9': _textoBoton('9', fontSize),
      'DEL': _iconoBoton(Icons.backspace_outlined, iconSize),
      '4': _textoBoton('4', fontSize),
      '5': _textoBoton('5', fontSize),
      '6': _textoBoton('6', fontSize),
      'x': _iconoBoton(Icons.close, iconSize),
      '1': _textoBoton('1', fontSize),
      '2': _textoBoton('2', fontSize),
      '3': _textoBoton('3', fontSize),
      '-': _iconoBoton(Icons.remove, iconSize),
      '0': _textoBoton('0', fontSize),
      '.': _textoBoton('.', fontSize),
      '/': _iconoBoton(FontAwesomeIcons.divide, iconSize),
      '+': _iconoBoton(Icons.add, iconSize),
      'C': _textoBoton('C', fontSize),
      '=': _textoBoton('=', fontSize),
      '(': _textoBoton('(', fontSize),
      ')': _textoBoton(')', fontSize),
    };

    return botones[texto] ?? Container();
  }

  Widget _textoBoton(String texto, double fontSize) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: fontSize,
        color: _colorTextoBoton(texto),
      ),
    );
  }

  Widget _iconoBoton(IconData icono, double iconSize) {
    return Icon(icono, size: iconSize);
  }

  Color _colorTextoBoton(String texto) {
    Map<String, Color> colores = {
      'C': Colors.red[400]!,
      '1': Colors.blue[300]!,
      '2': Colors.blue[300]!,
      '3': Colors.blue[300]!,
      '4': Colors.blue[300]!,
      '5': Colors.blue[300]!,
      '6': Colors.blue[300]!,
      '7': Colors.blue[300]!,
      '8': Colors.blue[300]!,
      '9': Colors.blue[300]!,
      '0': Colors.blue[300]!,
    };

    return colores[texto] ?? Colors.white70;
  }

  String _calcularResultado() {
    String calculoFinal = '';
    try {
      String inputHistorial = result;
      calculoFinal =
          Expression(result.replaceAll('x', '*').replaceAll('÷', '/'))
              .eval()
              .toString();
      if (calculoFinal != inputHistorial) {
        historial.add('$inputHistorial = $calculoFinal');
      }
    } catch (expresionException) {
      calculoFinal = 'Error';
    }
    return calculoFinal;
  }

  double _alturaCajaResultado(double screenWidth, String result, bool esMovil) {
    int length = result.length;

    if (screenWidth > 600) {
      screenWidth = 600;
    }

    if (length > 25) {
      return screenWidth * 0.05;
    } else if (length > 20) {
      return screenWidth * 0.07;
    } else if (length > 12) {
      return screenWidth * 0.09;
    } else if (length > 8) {
      return screenWidth * 0.11;
    } else if (length > 6) {
      return screenWidth * 0.13;
    } else {
      return screenWidth * 0.15;
    }
  }
}
