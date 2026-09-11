# Project_JL Design

## General Ideas

-   Past runthroughs of the game impact the current run.
-   The player has the ability to control and mould the game
    environment, potentially moving parts of the environment to kill
    enemies.
-   A highly interactable environment: if a player thinks they can do
    something, they should be able to. This could work in an action game
    where the player has to defeat enemies using normal, everyday
    objects.
-   Multiplayer where one player is combat-focused and the other is
    puzzle-focused, earning power-ups for the combat player.
-   A crazy, overwhelming management game where you have to dispatch
    first responders to emergencies.
-   Switch the angle at which you are viewing the game space in order to
    access new areas.
-   The player is able to morph between sizes, affecting how they
    interact with the game. For example, being big could mean being weak
    and slow, while being small could mean being strong and fast.
-   Implement an AI model that can dynamically change how a character
    talks back to the player or interacts with the player and the world.
-   Multiplayer where people can indirectly interact with other players'
    single-player experiences.
-   An action game where you are constantly chaining attacks together.

## Game Engines

### Godot

#### Pros

-   Open source and free, with greater freedom to make modifications to
    the game engine.
-   Already knowledgeable in the engine.
-   Smaller ecosystem and support requirements.

#### Cons

-   Possibly overkill depending on what we are making.
-   Very basic Git implementation.

### Unity

#### Pros

-   Free for personal use up to \$200,000 in revenue/funding.
-   Some existing knowledge of the engine.
-   Very old and established engine.
-   Jack-of-all-trades game engine.
-   C# support.

#### Cons

-   More bloated than Godot and contains more functionality due to its
    broader scope.

### Unreal

#### Pros

-   Very powerful game engine.
-   Used to create more complex 3D games.
-   Strong shader support.

#### Cons

-   Could be overkill.
-   Steep learning curve.
-   Not currently knowledgeable in the engine.

## Goals of Game Development

-   Make the game modular and easily maintainable.
-   Make good design choices.
-   Basic systems that are implemented repeatedly or across most games
    should be modular and generic.
-   Something smaller, polished, and complete is better than something
    huge that is incomplete and buggy.
