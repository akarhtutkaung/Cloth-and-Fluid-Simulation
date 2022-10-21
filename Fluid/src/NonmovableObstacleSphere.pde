class NonmovableObstacleSphere extends ObstacleSphere
{
  // public float radius;
  // public Vector3 position;

  float speed = 50.0f;

  public float ground;

  NonmovableObstacleSphere(Vector3 position, float radius, float ground){
    super.position = position;
    super.radius = radius;
    super.hit = false;
    this.ground = ground;
  }

  void Update(PVector forwardDir, PVector rightDir, float dt) {
    if(position.y + radius < ground + 20){
      position.y += dt * speed;
    } else {
      position.y = - radius + ground + 20;
    }
  }

  void HandleKeyPressed(){}

  void HandleKeyReleased(){}
}
