using Godot;
using System;

public partial class Main : Node
{
	private Player player;
	private InventoryInterface inventoryInterface;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		player = GetNode<Player>("Player");
        inventoryInterface = GetNode<InventoryInterface>("UI/InventoryInterface");

		inventoryInterface.SetPlayerInventoryData(player.InventoryData);
		
		player.Connect(nameof(player.ToggleInventory), new Callable(this, nameof(ToggleInventoryCallback)));
    }

	public void ToggleInventoryCallback()
    {
        inventoryInterface.Visible = !inventoryInterface.Visible;

		if(inventoryInterface.Visible)
		{
			   Input.MouseMode = Input.MouseModeEnum.Visible;
		}
		else
		{
            Input.MouseMode = Input.MouseModeEnum.Captured;
        }
    }

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

    public override void _UnhandledInput(InputEvent @event)
    {
		if(Input.IsActionJustPressed("exit"))
		{
			GetTree().Quit();
		}
    }
}
