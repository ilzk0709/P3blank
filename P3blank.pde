//Tamaño de ventana
int ancho = 720;          // Ancho de la ventana, en píxeles
int alto = 480;           // Alto de la ventana, en píxeles

//Variables para controlar la pared y el hueco
int paredX = 3*ancho/4;   // Posicion X de la pared, en píxeles
int paredW = 20;          // Ancho (width) de la pared, en píxeles 
int huecoH = 40;          // Altura (height) del hueco, en píxeles
int huecoY = 0;           // Posición Y del hueco, en píxeles
int huecoDeltaY = 2;      // Incremento en Y del hueco en cada iteración, en píxeles 

//Variables para controlar el cañón 
float cannonTheta = 0;              // Angulo del cañón, en radianes
float cannonDeltaTheta = PI/100.0;  // Incremento de ángulo al mover el cañón, en radianes
int v0 = 100;                       // Velocidad inicial que dará el cañón a la bala, en píxeles por segundo
int v0max = 600;                    // Máxima velocidad inicial que dará el cañón a la bala, en píxeles por segundo
int deltav0 = 6;                    // Incremento de velocidad inicial, en píxeles por segundo

//Animación del disparo
float fps = 30;     // Número de fotogramas por segundo
float h = 1/fps;  // Paso de tiempo, en segundos
boolean disparando = false;  // Variable de estado que indica si el cañón está disparando
float balaX;    // Posición X de la bala, en píxeles
float balaY;    // Posición Y de la bala, en píxeles
float balaVx;   // Velocidad X de la bala, en píxeles por segundo
float balaVy;   // Velocidad Y de la bala, en píxeles por segundo

float gravedad = 278;
int score = 0;
/////////////////////////////////////////

void setup() {
  size(720, 480);
  frameRate(fps);
}

/////////////////////////////////////////

void draw() {
  background(255);
  textSize(32);
  text("Score: " + score, 10, 30);

  //Pintar pared
  fill(0);
  rect(paredX, 0, paredW, alto);
  
  //Pintar y mover hueco
  fill(255);
  huecoY = huecoY + huecoDeltaY;
  if (huecoY >= alto - huecoH)
    huecoDeltaY = -huecoDeltaY;
  if (huecoY <= 0)
    huecoDeltaY = -huecoDeltaY;
  rect(paredX, huecoY, paredW, huecoH);
  
  //Movimiento del cañón con el teclado
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == UP) {
        cannonTheta = cannonTheta + cannonDeltaTheta;
        if (cannonTheta > PI/2)
          cannonTheta = PI/2;
      }
      else if (keyCode == DOWN) {
        cannonTheta = cannonTheta - cannonDeltaTheta;
        if (cannonTheta < 0)
          cannonTheta = 0;
      }
      else if (keyCode == LEFT) {
        v0 = v0 - deltav0;
        if (v0 < 0)
          v0 = 0;
      }
      else if (keyCode == RIGHT) {
        v0 = v0 + deltav0;
        if (v0 > v0max)
          v0 = v0max;
      }
    }
  }
     
  // Pintar cañón
  fill(255*v0/v0max, 0, 255*(v0max-v0)/v0max);
  pushMatrix();
  translate(0, alto-7.5);
  rotate(-cannonTheta);
  rect(-40, -15, 80, 30);
  popMatrix();
  
  //Iniciar animación
  if (keyPressed && disparando == false) {
    if (key == ENTER || key == RETURN) {
      disparando = true;
      
      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      //Inicialización a rellenar
      
      balaX = 10;
      balaY = 480;
      
      balaVx = v0 * cos(cannonTheta);
      println(balaVx);
      balaVy = -v0 * sin(cannonTheta);
      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      
    } //<>//
  }
    
  //Animación de disparo
  if (disparando) {
    
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //Bucle de animación a rellenar
    ellipse(balaX, balaY, 10,10);
    
    balaX = balaX + h*balaVx;

    balaVy = balaVy + h*gravedad;
    balaY = balaY + h*balaVy;
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    // El disparo termina si la bala sale de la ventana
    if (balaY > alto || balaY < 0 || balaX > ancho) {
      disparando = false;
    }
  }
}
