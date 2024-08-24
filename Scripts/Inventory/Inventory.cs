using Godot;
using System;

public partial class Inventory : PanelContainer
{
    private PackedScene Slot = GD.Load<PackedScene>("res://Instance/Inventory/Slot.tscn");

    private GridContainer itemGrid;
    

    public override void _Ready()
    {
        itemGrid = GetNode<GridContainer>("MarginContainer/ItemGrid");
    }

    public void SetInventoryData(InventoryData inventoryData)
    {
        inventoryData.InventoryUpdated += PopulateItemGrid;
        PopulateItemGrid(inventoryData);
    }

    public void PopulateItemGrid(InventoryData inventoryData)
    {
        foreach (var child in itemGrid.GetChildren())
        {
            child.QueueFree();
        }

        foreach(var slot in inventoryData.SlotData)
        {
            Slot slotInstance = Slot.Instantiate() as Slot;
            itemGrid.AddChild(slotInstance);

            slotInstance.SlotClicked += inventoryData.OnSlotClicked;

            if(slot != null)
            {
                slotInstance.SlotData = slot;
            }
        }
    }
}
