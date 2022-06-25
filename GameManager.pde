import processing.sound.*;

/**
* Class represent a game mananger
* can be used to
* -manage game scoring
* -set game level, speed and also to display game information
*/
class GameManager{
  // Define scoring variables
  int score;
  int scoreMultiplyer;
  int gameLevel;
  int missileReleaseRate;
  float speed;
  float releaseRateMultiplier;
  int numberOfRounds;
  int numberOfMissiles;
  
  // constructor to initialize all fields
  GameManager(){
    this.score = 0;
    this.scoreMultiplyer = 10;
    this.releaseRateMultiplier = 25;
    this.missileReleaseRate = 110;
    this.gameLevel = 1;
    this.numberOfRounds = 30;
    this.numberOfMissiles = numberOfRounds - 5;
    this.speed = 1.5;
    
  }
  
  /**
  * Method to increment game score
  * @return void
  */
  void incrementScore(){score += scoreMultiplyer;}
  
  /**
  * method to increment missile release rate
  * @return void
  */
  void incrementRealeaseRate(){
    
    missileReleaseRate -= releaseRateMultiplier;
    
    if (missileReleaseRate < 50) missileReleaseRate = 50;
  }

  /** 
  * Method to advance game level
  * @return void
  */
  void nextLevel() {
    
    gameLevel+=1;
    incrementRealeaseRate();
    score += numberOfRounds * 5;
    setNumberOfRounds(30);
    speed+=0.5;
  }
    
  /**
  * Method to retrieve game score
  * @return float
  */
  float getScore() { return score;}

  // Method to set missile release rate
  void setMissileReleaseRate(int missileReleaseRate) {
    this.missileReleaseRate = missileReleaseRate;
  }

  /**
  * Method to set speed
  * @return void
  */
  void setSpeed(int speed) {
    this.speed = speed;
  }

  /** 
  * Method to set missile release rate multiplier
  * @return void
  */
  void setReleaseRateMultiplier(float releaseRateMultiplier) {
    this.releaseRateMultiplier = releaseRateMultiplier;
  }

  /**
  * Method to set number of missile rounds
  * @return void
  */
  void setNumberOfRounds(int numberOfRounds) {
    this.numberOfRounds = numberOfRounds;
  }
  
  /**
  * Method to decrement number of missile rounds
  * @return void
  */
  void decrementNumberOfRounds(){
    numberOfRounds--;
  }
  
  /**
  * Method to reset number of missiles
  * @return void
  */
  void resetNumberOfMissiles(){numberOfMissiles = numberOfRounds-5;}
  
   /**
   * Method to show game information
  * @return void
  */
  void showGameInfo(){
    
    // Score text
    textSize(20);
    textAlign(LEFT);
    fill(255);
    text("Score = " + getScore(), 20, 20);
    // Level text
    text("Level = " + gameLevel, 20, 40);
    // Rounds text
    text("Rounds = " + numberOfRounds, 20, 60);
  }
 
  /**
  * Method to display total game info user fails
  * @return void
  */
  void showGameOver(){
   
    background(0);
    textSize(32);
    fill(175,180,255);
    textAlign(CENTER);
    // message to be displayed depending on wether prgress in made or player fails
    String message = gameLevel > 10 ? "ALL LEVELS COMPLETED" : "GAME OVER";
    text(message, width/2, height/2);
    textSize(24);
    fill (255,0,0);
    text("Final score: " + score, width/2, height/2 + 40);
 }
}
