using Godot;
using System;

public partial class Slot : PanelContainer
{
    private TextureRect textureRect;
    private Label quantityLabel;

    [Signal] public delegate void SlotClickedEventHandler(int index, int button);

    public SlotData SlotData { 
        get
        {
            return SlotData;
        }

        set
        {
            var itemData = value.Item;
            textureRect.Texture = (Texture2D)itemData.Texture;
            string text = $"{itemData.Name}\n{itemData.Description}";
                
            if(value.Quantity > 1)
            {
                Logger.Log("More than 1 item in slot");
                quantityLabel.Text = $"x{value.Quantity}";
                quantityLabel.Visible = true;
            }
            else
            {
                Logger.Log("1 item in slot");
            }
        }
    }

    public override void _Ready()
    {
        textureRect = GetNode<TextureRect>("MarginContainer/TextureRect");
        quantityLabel = GetNode<Label>("QuantityLabel");
    }

    public override void _GuiInput(InputEvent @event)
    {
        if(@event is InputEventMouseButton mouseButton && (mouseButton.ButtonIndex == MouseButton.Left || mouseButton.ButtonIndex == MouseButton.Right) && mouseButton.Pressed)
        {
            EmitSignal(nameof(SlotClicked), GetIndex(), (int) mouseButton.ButtonIndex);
        }
    }
}
