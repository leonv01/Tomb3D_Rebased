using Godot;
using System;

[GlobalClass]
public partial class ItemData : Resource
{
    [Export] public string Name { get; set; } = "";
    [Export(PropertyHint.MultilineText)] public string Description { get; set; } = "";
    [Export] public bool IsStackable { get; set; } = false;
    [Export] public Texture Texture { get; set; }
}
