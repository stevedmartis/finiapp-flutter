import 'package:finia_app/constants.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/widgets/reouter_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _showButton = false;

  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/images/projections.svg",
      "title": "¡Todas tus cuentas, \na tu pinta! 😎",
      "description":
          "Olvídate del desorden. FinIA junta tus cuentas y tarjetas en un solo lugar. ¡Maneja tu plata fácil y rápido! 😉"
    },
    {
      "image": "assets/images/vault.svg",
      "title": "¡Tu dinero seguro, \ntus metas claras! 😉",
      "description":
          "FinIA protege tu información con seguridad de nivel bancario. ¡Controla tus gastos y ahorra para tus sueños sin preocupaciones! 🔐"
    },
    {
      "image": "assets/images/investor_update.svg",
      "title": "¡Invierte como un experto! 🚀",
      "description":
          "Obtén recomendaciones personalizadas y claras para hacer crecer tu dinero. ¡Con FinIA, invertir es Izi Pizi! 💪"
    }
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      if (index == _onboardingData.length - 1) {
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _showButton = true;
          });
        });
      } else {
        _showButton = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [darkCardBackground, darkCardBackground],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        )),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) => OnboardingPage(
                image: _onboardingData[index]['image']!,
                title: _onboardingData[index]['title']!,
                description: _onboardingData[index]['description']!,
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => buildDot(index, context),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: _showButton ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 900),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [logoCOLOR1, logoCOLOR2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          if (_currentIndex == _onboardingData.length - 1) {
                            /*                       Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BublesSuccesPage(
                                          orders: myProducts,
                                        )));
 */
                            Navigator.push(
                                context, bubleSuccessRouter(myProducts));
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 12,
      width: 12,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: _currentIndex == index ? logoCOLOR1 : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          SvgPicture.asset(
            image,
            height: 300,
          ),
          const SizedBox(height: 30),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
