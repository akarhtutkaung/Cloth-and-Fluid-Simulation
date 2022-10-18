class MovableObstacleSphere extends ObstacleSphere
{
  // public float radius;
  // public Vector3 position;
  boolean goFront = false;
  boolean goBack = false;
  boolean goLeft = false;
  boolean goRight = false;

  MovableObstacleSphere(Vector3 position, float radius){
    super.position = position;
    super.radius = radius;
  }

  void Update(PVector forwardDir, PVector rightDir, float dt) {
    if (goFront == true) {
      position.x += forwardDir.x;
      position.z += forwardDir.z;
    }
    if(goBack == true) {
      position.x -= forwardDir.x;
      position.z -= forwardDir.z;
    }
    if(goLeft) {
      position.x -= rightDir.x;
      position.z -= rightDir.z;
    }
    if(goRight) {
      position.x += rightDir.x;
      position.z += rightDir.z;
    }
  }

  void HandleKeyPressed(){
    if (keyCode == UP) {
      goFront = true;
    } 
    if (keyCode == DOWN) {
      goBack = true;
    } 
    if (keyCode == LEFT) {
      goLeft = true;
    }
    if (keyCode == RIGHT) {
      goRight = true;
    }
  }

  void HandleKeyReleased(){
    if (keyCode == UP) {  
      goFront = false;
    } 
    if (keyCode == DOWN) {
      goBack = false;
    } 
    if (keyCode == LEFT) {
      goLeft = false;
    }
    if (keyCode == RIGHT) {
      goRight = false;
    }
  }
}