class Node
{
  public Vector3 position;
  public Vector3 velocity;
  public Vector3 velocityH;
  public Vector3 acceleration;
  public Vector3 accelerationH;
  public float u;
  public float v;
  
  Node(Vector3 position){
    this.position = position;
    velocity = new Vector3(0, 0, 0);
    velocityH = new Vector3(0, 0, 0);
    acceleration = new Vector3(0, 0, 0);
    accelerationH = new Vector3(0, 0, 0);
  }
  
  void resetAcceleration(){
    acceleration = new Vector3(0, 0, 0);
  }

  void resetAccelerationH(){
    accelerationH = new Vector3(0, 0, 0);
  }

  void addToAcceleration(Vector3 acc){
    acceleration.add(acc);
  }

  void addToVelocity(Vector3 vel){
    velocity.add(vel);
  }

  void addToPosition(Vector3 pos){
    position.add(pos);
  }

  void subtractFromVelocity(Vector3 vel){
    velocity.subtract(vel);
  }

  void setUV(float u, float v){
    this.u = u;
    this.v = v;
  }

}