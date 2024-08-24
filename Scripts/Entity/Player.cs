using Godot;
using System;
using System.Net.Http;

public partial class Player : CharacterBody3D
{
	// Controls ---------------------
	[ExportCategory("Controls")]
    [Export] public float Sensivity = 0.001f;
    [Export] public int MaxLookDownAngle = -90;
    [Export] public int MaxLookUpAngle = 90;
	[Export] public float Speed = 5.0f;
	[Export] public float RunSpeed = 10.0f;
	[Export] public float JumpVelocity = 10.0f;

    // Object References ---------------------
    private Node3D head;
	private Camera3D camera;
	private Control HUD;
	private Label infoLabel;
	private RayCast3D interactCast;

	// Inventory ---------------------
	[Export] public InventoryData InventoryData { get; set; }
	[Signal] public delegate void ToggleInventoryEventHandler();

	public Role PlayerRole { get; private set; }

	public enum PlayerState
	{
		Idle, Walking, Running, Jumping, Falling, Crouching, Dead
	}

	public PlayerState State { get; private set; } = PlayerState.Idle;

    public override void _Ready()
    {
		head = GetNode<Node3D>("Head");
		camera = head.GetNode<Camera3D>("Camera");
		HUD = GetNode<Control>("HUD");
		infoLabel = HUD.GetNode<Label>("InfoLabel");

		interactCast = camera.GetNode<RayCast3D>("InteractCast");

		Input.MouseMode = Input.MouseModeEnum.Captured;

        PlayerRole = new Mage();
		PlayerRole.Health = 10;
		PlayerRole.MaxHealth = 200;
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (@event is InputEventMouseMotion mouseEvent && Input.MouseMode == Input.MouseModeEnum.Captured)
        {
            head.RotateY(-mouseEvent.Relative.X * Sensivity);
            camera.RotateX(-mouseEvent.Relative.Y * Sensivity);
			Vector3 vector3 = camera.Rotation;
			vector3.X = Mathf.Clamp(camera.Rotation.X, Mathf.DegToRad(MaxLookDownAngle), Mathf.DegToRad(MaxLookUpAngle));
			camera.Rotation = vector3;
        }

		if(Input.IsActionJustPressed("inventory"))
		{
			EmitSignal(nameof(ToggleInventory));
		}

        if (Input.IsActionJustPressed("interact"))
        {
            if (interactCast.IsColliding())
            {
                Node collider = (Node)interactCast.GetCollider();

                if (collider.IsInGroup("Potion"))
                {
                    Logger.Log("Potion");
                }
            }
        }

        if (Input.IsActionJustPressed("run"))
        {
            State = PlayerState.Running;
        }
        else if (Input.IsActionJustReleased("run"))
        {
            State = PlayerState.Walking;
        }

        if (Input.IsActionJustPressed("attack"))
        {
            PlayerRole.PrimaryAttack();
        }
        else if (Input.IsActionJustPressed("secondary"))
        {
            PlayerRole.SecondaryAttack();
        }
    }

    public override void _Process(double delta)
    {
		UpdateHUD();
    }

    public override void _PhysicsProcess(double delta)
	{
		float deltaTime = (float)delta;

		Vector3 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * deltaTime;
		}

		// Handle Jump.
		if (Input.IsActionJustPressed("jump") && IsOnFloor())
		{
			velocity.Y = JumpVelocity;
			State = PlayerState.Jumping;
		}

		Vector2 inputDir = Input.GetVector("left", "right", "up", "down");
		Vector3 direction = (head.Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();

		float targetSpeed = (State == PlayerState.Running) ? RunSpeed : Speed;

		float currentSpeed = Mathf.Lerp(Velocity.Length(), targetSpeed, 5.0f * deltaTime);

		if (direction != Vector3.Zero)
		{
			velocity.X = direction.X * currentSpeed;
			velocity.Z = direction.Z * currentSpeed;

			if(State != PlayerState.Running)
            {
				State = PlayerState.Walking;
            }
        }
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, currentSpeed);
			velocity.Z = Mathf.MoveToward(Velocity.Z, 0, currentSpeed);
		}

		Velocity = velocity;
		MoveAndSlide();
	}

	public void UpdateHUD()
	{
		infoLabel.Text = $"" +
			$"Position: {GlobalTransform.Origin}\n" +
			$"State: {State}\n" +
			$"Speed: {Velocity.Length()}\n" +
			$"{PlayerRole}\n" +
			$"{Engine.GetFramesPerSecond()}";
	}
}
