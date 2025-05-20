import 'package:flutter/material.dart';

class onboardingcard extends StatelessWidget {
  final String image;
  final String logo;
  final String title;
  final String buttonText;
  final VoidCallback onPressed;

  const onboardingcard({
    super.key,
    required this.image,
    required this.logo,
    required this.title,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                logo,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 100.0),
                child: Center(
                    child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
              ),
              MaterialButton(
                minWidth: 300,
                onPressed: onPressed,
                color: Colors.white,
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
