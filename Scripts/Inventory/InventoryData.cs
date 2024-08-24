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

    public void SetSlotData(int index, ref SlotData grabbedSlotData)
    {
        if(index >= 0 && index < SlotData.Length)
        {
            SlotData slotData = SlotData[index];

            SlotData returnSlotData = null;

            if(slotData != null && slotData.CanMergeWithItem(grabbedSlotData))
            {
                Logger.Log("Merging items");
                slotData.MergeWithItem(grabbedSlotData);
            }
            else
            {
                Logger.Log("Swapping items");
                SlotData[index] = grabbedSlotData;
                returnSlotData = slotData;
            }

            grabbedSlotData = returnSlotData;

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
