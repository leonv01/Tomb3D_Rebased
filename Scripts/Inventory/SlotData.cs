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
        return (
            Item == slotData.Item &&
            Item.IsStackable &&
            Quantity + slotData.Quantity <= MAX_STACK_SIZE
            );
    }

    public void MergeWithItem(SlotData slotData)
    {
        Logger.Log($"Merging {slotData.Quantity} {Item.Name} with {Quantity} {Item.Name}");
        Quantity += slotData.Quantity;
    }
}
