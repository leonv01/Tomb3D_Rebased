using Godot;
using System;

public partial class Item : Area3D
{
    [Export] public int healFactor = 50;
    [Export] public float RotationSpeed = 90.0f;
	[Export] public float moveAmplitude = 0.5f;
	[Export] public float moveSpeed = 2.0f;

	private Vector3 startPosition;
	private float timePassed = 0.0f;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		startPosition = GlobalTransform.Origin;

		this.BodyEntered += OnBodyEntered;
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		float deltaTime = (float)delta;

		timePassed += deltaTime;

		RotateY(Mathf.DegToRad(RotationSpeed * deltaTime));

		float newY = startPosition.Y + Mathf.Sin(timePassed * moveSpeed) * moveAmplitude;

		GlobalTransform = new(GlobalTransform.Basis, new(startPosition.X, newY, startPosition.Z));
	}

	public void OnBodyEntered(Node body)
    {
        if(body is Player player)
		{
			if(player.PlayerRole != null)
			{
				player.PlayerRole.Heal(healFactor);
				Logger.Log("Player healed by " + healFactor + " points");
				QueueFree();
			}

        }
    }

	protected virtual void OnItemPickedUp(Player player)
	{
		if(player.PlayerRole != null)
		{
			player.PlayerRole.Heal(healFactor);
			Logger.Log("Player healed by " + healFactor + " points");
			QueueFree();
		}
	}
}
