## Question

How can I use Phoenix Presence to track LiveView processes, while still relying on the state
from a single GenServer process as the source of truth for all connected LiveView processes?

A more concrete example of this question is an app that allows users to join a trivia game
and play against each other to answer questions for points. I want the GameServer (a GenServer)
to be the source of truth for the details of a game, including who the players are. Each
LiveView process will need to store a copy of the game state from GameServer.

[Shown here](), one option could be to [track](https://hexdocs.pm/phoenix/Phoenix.Presence.html#c:track/4) each LiveView process
using a topic that they are subscribed to. When players join and leave the game, the `"presence_diff"` event can
be handled by each subscribed LiveView process. To handle the event, each LiveView process would
use the GameServer API to update their own copy of the game state. The thing I don't like about this
approach is that the flow of data seems a little backwards to me (eg. Presence tells the LiveView processes
about players, and then each LiveView process tells the GameServer).

Another option [shown here]() would be to still [track](https://hexdocs.pm/phoenix/Phoenix.Presence.html#c:track/4) each LiveView process,
but using a dedicated topic, which only the GameServer process is subscribed to (eg. `"game:presences:<game_id>"`). The GameServer process
itself could handle `"presence_diff"`, and broadcast the updated game state (including players) to each LiveView process over
another topic (eg. `"game:updates:<game_id>"`). I like this approach because the data flow makes sense to me:
Presence tells the GameServer about players, and the GameServer lets all the LiveView's know. It also makes the LiveView
code simpler. A question I have though, is if this design defeats the purpose of using Phoenix Presence?

Curious to know if one of these approaches would be better than the other, or if there's some other alternative
that I haven't considered. Maybe both options are fine?
