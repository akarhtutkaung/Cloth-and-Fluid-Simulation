class Node
{
  public Vector2 position;
  public Vector2 velocity;
  public Vector2 velocityH;
  public Vector2 acceleration;
  public Vector2 accelerationH;
  
  Node(Vector2 position){
    this.position = position;
    velocity = new Vector2(0, 0);
    velocityH = new Vector2(0, 0);
    acceleration = new Vector2(0, 0);
    accelerationH = new Vector2(0, 0);
  }
  
  void resetAcceleration(){
    acceleration = new Vector2(0, 0);
  }

  void resetAccelerationH(){
    accelerationH = new Vector2(0, 0);
  }

  void addToAcceleration(Vector2 acc){
    acceleration.add(acc);
  }

  void addToVelocity(Vector2 vel){
    velocity.add(vel);
  }

  void addToPosition(Vector2 pos){
    position.add(pos);
  }

  void subtractFromVelocity(Vector2 vel){
    velocity.subtract(vel);
  }

}