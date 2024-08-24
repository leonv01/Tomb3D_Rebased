using Godot;
using System;

[GlobalClass]
public partial class SlotData : Resource
{
    private const int MAX_STACK_SIZE = 99;
    private int quantity;

    [Export] public ItemData Item { get; set; }
    [Export(PropertyHint.Range, "1, 99")]
    public int Quantity
    {
        get => quantity;
        set
        {
            quantity = value;

            if (quantity > 1 && !Item.IsStackable)
            {
                quantity = 1;
                Logger.LogError($"Item {Item.Name} is not stackable.");
            }
        }
    }

    public bool CanMergeWithItem(SlotData slotData)
    {
        Logger.Log("Trying to merge items");
        return (
            slotData != null &&
            Item == slotData.Item &&
            Item.IsStackable &&
            Quantity + slotData.Quantity <= MAX_STACK_SIZE
            );
    }

    public void MergeWithItem(SlotData slotData)
    {
        Quantity += slotData.Quantity;
    }
}
