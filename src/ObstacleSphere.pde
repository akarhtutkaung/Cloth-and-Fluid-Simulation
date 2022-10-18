abstract class ObstacleSphere
{
  public float radius;
  public Vector3 position;
  public boolean hit;

  public abstract void HandleKeyPressed();
  public abstract void HandleKeyReleased();
  public abstract void Update(PVector forwardDir, PVector rightDir, float dt);
}