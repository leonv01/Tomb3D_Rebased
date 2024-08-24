using Godot;
using System;
using System.Reflection;

public partial class InventoryInterface : Control
{
	private Inventory playerInventory;
	private Slot grabbedItem;
	private SlotData grabbedItemData = null;


	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
        playerInventory = GetNode<Inventory>("PlayerInventory");
        grabbedItem = GetNode<Slot>("GrabbedItem");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void SetPlayerInventoryData(InventoryData inventoryData)
	{
        inventoryData.InventoryInteract += OnInventoryInteract;
		playerInventory.SetInventoryData(inventoryData);
	}

    public void OnInventoryInteract(InventoryData inventoryData, int index, int button)
    {
		if(grabbedItemData == null)
		{
			Logger.Log("Grabbed item is null");
		}
		switch(grabbedItemData, button)
		{
			case (null, (int)MouseButton.Left):
				inventoryData.GetSlotData(index, ref grabbedItemData);
                break;
			case (_, (int)MouseButton.Left):
				Logger.Log("Test");
				inventoryData.SetSlotData(index, ref grabbedItemData);
				break;
		}

		UpdateGrabbedItem();
    }

    public override void _PhysicsProcess(double delta)
    {
		float deltaTime = (float)delta;

        if (grabbedItem.Visible)
        {
			grabbedItem.Position = GetGlobalMousePosition() + new Vector2(5, 5);
        }
    }

    public void UpdateGrabbedItem()
	{
		if(grabbedItemData != null)
		{
			grabbedItem.Visible = true;
			grabbedItem.SlotData = grabbedItemData;
        }
		else
		{
			grabbedItem.Visible = false;
        }
	}
}
