import 'dart:isolate';
import 'package:flutter/material.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _translationController;

  String _result = 'Presiona un botón para calcular números primos';
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();

    // Controlador para la rotación
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Controlador para la traslación (movimiento)
    _translationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demostración de Isolates')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Área de animación
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _rotationController,
                  _translationController,
                ]),
                builder: (context, child) {
                  return CustomPaint(
                    painter: SquarePainter(
                      rotation: _rotationController.value * 2 * 3.14159,
                      translation: _translationController.value,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Resultado del cálculo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resultado:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(_result, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isCalculating
                      ? null
                      : () => _calculatePrimesInMainThread(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Calcular en\nMain Thread'),
                ),
                ElevatedButton(
                  onPressed: _isCalculating
                      ? null
                      : () => _calculatePrimesInIsolate(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Calcular en\nIsolate'),
                ),
              ],
            ),
            if (_isCalculating)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  // Calcular números primos en el main thread (bloquea la animación)
  Future<void> _calculatePrimesInMainThread() async {
    setState(() {
      _isCalculating = true;
      _result = 'Calculando en Main Thread...';
    });

    final stopwatch = Stopwatch()..start();
    final primes = _calculatePrimes();
    stopwatch.stop();

    setState(() {
      _isCalculating = false;
      _result =
          'Encontrados ${primes.length} números primos\n'
          'Tiempo: ${stopwatch.elapsedMilliseconds}ms\n'
          '⚠️ La animación se bloqueó durante el cálculo';
    });
  }

  // Calcular números primos en un isolate (no bloquea la animación)
  Future<void> _calculatePrimesInIsolate() async {
    setState(() {
      //_isCalculating = true;
      _result = 'Calculando en Isolate...';
    });

    final stopwatch = Stopwatch()..start();
    final primes = await Isolate.run(() => _calculatePrimes());
    stopwatch.stop();

    setState(() {
      //_isCalculating = false;
      _result =
          'Encontrados ${primes.length} números primos\n'
          'Tiempo: ${stopwatch.elapsedMilliseconds}ms\n'
          '✅ La animación siguió fluida';
    });
  }

  // Función pesada: calcular números primos hasta un límite
  static List<int> _calculatePrimes() {
    final int limit = 4000000;
    final List<int> primes = [];

    for (int num = 2; num <= limit; num++) {
      bool isPrime = true;

      // Verificar si es primo
      for (int i = 2; i * i <= num; i++) {
        if (num % i == 0) {
          isPrime = false;
          break;
        }
      }

      if (isPrime) {
        primes.add(num);
      }
    }

    return primes;
  }
}

// Custom painter para dibujar el cuadrado animado
class SquarePainter extends CustomPainter {
  final double rotation;
  final double translation;

  SquarePainter({required this.rotation, required this.translation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Calcular posición basada en la traslación (movimiento circular)
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = (size.width < size.height ? size.width : size.height) * 0.3;

    final x = centerX + radius * (translation * 2 - 1);
    final y = centerY + radius * (translation * 2 - 1) * 0.5;

    // Guardar el estado del canvas
    canvas.save();

    // Trasladar al centro del cuadrado
    canvas.translate(x, y);

    // Rotar
    canvas.rotate(rotation);

    // Dibujar el cuadrado centrado
    const squareSize = 40.0;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset.zero,
        width: squareSize,
        height: squareSize,
      ),
      const Radius.circular(4),
    );

    canvas.drawRRect(rect, paint);

    // Restaurar el estado del canvas
    canvas.restore();
  }

  @override
  bool shouldRepaint(SquarePainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.translation != translation;
  }
}
