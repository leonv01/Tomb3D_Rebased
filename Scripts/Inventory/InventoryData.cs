using Godot;
using System;

[GlobalClass]
public partial class InventoryData : Resource
{
    [Signal] public delegate void InventoryInteractEventHandler(InventoryData inventoryData, int index, int button);
    [Signal] public delegate void InventoryUpdatedEventHandler(InventoryData inventoryData);

    [Export] public SlotData[] SlotData { get; set; }

    public void OnSlotClicked(int index, int button)
    {
        EmitSignal(nameof(InventoryInteract), this, index, button);
    }

    public SlotData this[int index]
    {
        get
        {
            if(index >= 0 && index < SlotData.Length)
            {
                return SlotData[index];
            }
            return null;
        }
    }

    public void SetSlotData(int index, ref SlotData slotData)
    {
        if(index >= 0 && index < SlotData.Length)
        {
            var temp = SlotData[index];
            SlotData[index] = slotData;

            if (temp == null)
            {
                slotData = null;
            }
            else
            {
                slotData = temp;
            }


            EmitSignal(nameof(InventoryUpdated), this);
        }
    }

    public void GetSlotData(int index, ref SlotData grabbedItem)
    {
        SlotData slotData = null;

        if(index >= 0 && index < SlotData.Length)
        {
            var temp = SlotData[index];
            slotData = temp;
            SlotData[index] = null;

            EmitSignal(nameof(InventoryUpdated), this);
        }

        grabbedItem = slotData;
    }
}
