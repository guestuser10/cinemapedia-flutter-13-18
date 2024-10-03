import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Un widget personalizado para la barra de navegación inferior
class CustomBottomNavigation extends StatelessWidget {

  // Índice actual de la pestaña seleccionada
  final int currentIndex;

  // Constructor que requiere el índice actual
  const CustomBottomNavigation({
    super.key, 
    required this.currentIndex
  });

  // Método que maneja la navegación cuando se selecciona un ítem
  void onItemTapped(BuildContext context, int index) {
    // Navega a la ruta correspondiente según el índice seleccionado
    switch(index) {
      case 0:
        context.go('/home/0');
        break;
      
      case 1:
        context.go('/home/1');
        break;

      case 2:
        context.go('/home/2');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // Índice actual de la pestaña seleccionada
      currentIndex: currentIndex,
      // Llama al método onItemTapped cuando se selecciona un ítem
      onTap: (value) => onItemTapped(context, value),
      elevation: 0,
      // Define los ítems de la barra de navegación
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Inicio'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Categorías'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos'
        ),
      ]
    );
  }
}