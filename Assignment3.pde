import processing.sound.*;
/***************************************************************************#**********************
* Missile Command
* 
* This program uses the PImage and image functions to to laod and display images.
* Arrays are used to keep count and tack of of missiles fired.
* Mouse movement and other mouse events are then to calculate angles when a player clicks on the game canvas.
* Sound effects are used and controlled through mousePressed event and during collisions between missiles.
* The score is incremented every time an offensive missile is destroyed.
* Missile destruction is occurs when collission is detected using using simple collision detection algorythm.
* Buildings are destroyed when an offensive missile collides with a building.
* The game ends when all buildings are destroyed.
*
* To run this program, make sure you have the processing software installed on your computer.
* Copy the pde file and other necessary files to your desired folder and double click on the file to run the program.
* Alternatively, you can copy and paste this code on a new peocessing sketch, save it, and then copy all necessary files
* to the sketch folder. Make sure you have the sound library installed before runnig the program.
*
* Sound sources
* https://www.freesoundslibrary.com/fly-noise
*
* image sources
* www.abdawaoc.vercel.app
* https://www.hiclipart.com/free-transparent-background-png-clipart-imata/download
*
* @Author Francis Ozoka
* @Author Brendan Dodds
* @Author Angus Virgona 
*
**************************************************************************************************/

Canon canon;
ArrayList <DefenceMissile> defenceMissiles; // ArrayList to hold DeffenceMissiles objects
ArrayList <Missile> missiles; // Array to hold offence Missile objects
ArrayList <Missile> destroyedMissiles; // Array to hold destroyed missiles
boolean displayText = true; // Used to decied wether or not to display transition text
PImage[] images; // Array to hold explosion images
Explosion explosion;
int i = 0;
int missileCount;
int transitionFrames;
ArrayList<City> cities; // ArrayLiist to hold cithy objects
City city;
PFont font;
boolean gameOver;
boolean transitioning;
SoundFile missileFire;
SoundFile missileExplossion;
GameManager gameManager;

void setup(){
  size(1200, 800);
  canon = new Canon(width/2,height,10,40);
  defenceMissiles = new ArrayList<>();
  missiles = new ArrayList<>();
  destroyedMissiles = new ArrayList<>();
  imageMode(CENTER);
  ellipseMode(CENTER);
  images = new PImage[19];
  transitionFrames = 60;
  transitioning = false;
  missileFire = new SoundFile(this, "sounds/missile_fire.aiff");
  missileExplossion = new SoundFile(this, "sounds/Small_explosion.aiff");
  gameManager = new GameManager();
  missileCount = gameManager.numberOfMissiles;

  for (int i=0; i<images.length; i++){ //populate image array
      images[i] = loadImage("explosion/frame_"+i+".png");
  }
  
  cities = new ArrayList<>();
  populateCities();
  font = createFont("Arial", 24, true);
  
}

void draw(){
  
  if (gameOver == false) {
    
    // if out of missile roundsand missiles are still raining down on the city, or 
    //level is greater than 10, or the canon has been hit, end game
    if ((gameManager.numberOfRounds == 0 && !allMissilesExploded()) || allCitiesDestroyed()
    || gameManager.gameLevel > 10 || canon.distroyed) gameOver = true;
                                                                                                            
    i++;
    // add missiles to missiles array until missileCount is zero
    if(i % gameManager.missileReleaseRate == 0 && missileCount > 0) {
      
      missiles.add(new Missile(random(0, width), 0, gameManager.speed));
      missileCount--;
      
    }
    
    background(#3a3b4f);
    smooth();
    
    for(int i=0; i<missiles.size(); i++){// loop through missiles array and update positions
      
      Missile missile = missiles.get(i);
      missile.move(defenceMissiles, missiles);
      missile.show();
      
      // Check if the current missile already exists in the exploded array, 
      // if so don't increment the score
      if (missile.exploded == true && !destroyedMissiles.contains(missile)) {
        
        destroyedMissiles.add(missile);
        
      }
    
    }
  
    fill(0);
    canon.show(); // draw canon on the screen
    
    // loop through defenceMissiles and update positions
    for (int i=0; i<defenceMissiles.size(); i++){
      
      DefenceMissile defenceMissile = defenceMissiles.get(i);
      defenceMissile.move();
      defenceMissile.show();
      
      //if(defenceMissiles.get(i).explosion.finished){
        
      //  defenceMissiles.remove(i);
        
      //}
      
    }
    
    drawCities();// draw city buildings
    
    // if all released missiles are also in destroyedMissiles
    if ((destroyedMissiles.containsAll(missiles) && destroyedMissiles.size() == 
    gameManager.numberOfMissiles) || 
    (!allCitiesDestroyed() && allMissilesExploded())) {
      
      transitioning = true;
      
    }
    
    // draw game information on the screen
    gameManager.showGameInfo();
    
    if(transitioning){// transition ios transition flag is set to true
      
      transition();
    }
    
  }else { // show end game information
    gameManager.showGameOver();
  }
  
}

void mousePressed(){
  
  // only draw missiles outside the bounding box of the canon
  if(mouseX-canon.centerX > 45 || mouseX-canon.centerX < -45 || canon.centerY-mouseY > 45 ){
    
    if(gameManager.numberOfRounds > 0){
      
      missileFire.play(); // play firing sound
      defenceMissiles.add(canon.fire()); // add missile to array
      gameManager.decrementNumberOfRounds();
      
    }
    
  }

}

/**
* Method to populate citiies array
* @return void
*/
void populateCities(){
  
  float spacing = ((width/2) - 3*(new City(0).cityWidth))/3; // calculate spacing between cities
  float start = spacing;
    
  for (int i=0; i<=5; i++){ // add six cities to the cities array
    
    cities.add(new City(start));
    
    if (cities.size() < 3){ 
      // get previous cities end and add spacing
      start = cities.get(cities.size()-1).getEnd() + spacing;
      
    }else { // skip to the other side of the canon
      
      if (cities.size() == 3){
        
        start = width/2 + 100;
        
      }else start = cities.get(cities.size()-1).getEnd() + spacing;
      
    }
  }
}

/**
* Method to draw cities
* @return void
*/
void drawCities(){
  // loop through cities array and draw each one
  for(int i=0; i<cities.size(); i++){
    
    City city = cities.get(i);
    city.show();
    
    if (city.collide(missiles)){// check for collisions and initiate crumbleng animation
      
      city.crumbling = true;
      
    }
  }
}

/**
* Method to reset arrays and game variables
* @return void
*/
void resetLevel(){
  
  missiles.clear();
  destroyedMissiles.clear();
  gameManager.nextLevel();
  missileCount = gameManager.numberOfMissiles;
  gameManager.resetNumberOfMissiles();
  transitionFrames = 100;
  i = 0;
  
  if (gameManager.gameLevel > 10) gameOver = true; 
}

/** 
* Method to check if allthe cirties have been destroyed
* @return boolean
*/
boolean allCitiesDestroyed(){
  
  for(City city : cities){
    
    if (!city.crumbled){
      return false;
    }
    
  }
  return true;
}

/**
* method to to check if all offence missiles have exploded
* @return boolean
*/
boolean allMissilesExploded(){
  
  if (missiles.size() == 0) return false;
  
  for(Missile missile : missiles){
    
    if (!missile.exploded){
      return false;
    }
    
  }
  return true;
}

/**
* method to show transition animation
* @return void
*/
void transition(){
  
 if(i % 20 == 0 ) displayText = !displayText; // negate displayText every 20 frames
 
  if (transitioning && transitionFrames > 0){
    
    textAlign(CENTER);
    fill(0);
    textSize(40);
    
    if (displayText){
      // draw text
      text("LEVEL "+ gameManager.gameLevel+ " COMPLETED", width/2, height/2);
      transitionFrames--;
      
    }
  }else {
    
    resetLevel();
    transitioning = false;
    
  }
}

  
