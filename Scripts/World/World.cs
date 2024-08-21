using Godot;
using System;

public partial class World : Node3D
{
    private void HandleInput()
    {
        if(Input.IsActionJustPressed("exit"))
        {
            Logger.Log("Exiting game...");
            GetTree().Quit();
        }
    }

    public override void _Process(double delta)
    {
        HandleInput();
    }
}
