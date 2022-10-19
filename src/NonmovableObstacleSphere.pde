class NonmovableObstacleSphere extends ObstacleSphere
{
  // public float radius;
  // public Vector3 position;

  public float ground;

  NonmovableObstacleSphere(Vector3 position, float radius, float ground){
    super.position = position;
    super.radius = radius;
    super.hit = false;
    this.ground = ground;
  }

  void Update(PVector forwardDir, PVector rightDir, float dt) {
    if(position.y + radius < ground){
      position.y += dt * 0.03f;
    } else {
      position.y = - radius + ground;
    }
  }

  void HandleKeyPressed(){}

  void HandleKeyReleased(){}
}
