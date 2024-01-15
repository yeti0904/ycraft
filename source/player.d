module ycraft.player;

import std.math;
import ycraft.types;
import ycraft.world;
import ycraft.entity;
import ycraft.video;

class Player : Entity {
	Vec2!double velocity; // blocks per second

	this() {
		hitbox  = SDL_FRect(0, 0, 1.0, 2.0);
		physics = new PlayerPhysicsController();
	}
}

class PlayerPhysicsController : PhysicsController {
	private void Collision(Player player, World world, bool vertical) {
		auto start = Vec2!int(
			cast(int) floor(player.hitbox.x), cast(int) floor(player.hitbox.y)
		);
		auto end = Vec2!int(
			cast(int) ceil(player.hitbox.x + player.hitbox.w),
			cast(int) ceil(player.hitbox.x + player.hitbox.h)
		);

		for (int x = start.x; (x < world.size.x) && (x <= end.x); ++ x) {
			for (int y = start.y; (y < world.size.y) && (y <= end.y); ++ y) {
				auto block     = world.GetBlock(x, y);
				auto blockRect = SDL_FRect(
					cast(float) x, cast(float) y, 1.0, 1.0
				);

				if (block.type == 0) continue;

				if (SDL_HasIntersectionF(&blockRect, &player.hitbox) == SDL_TRUE) {
					SDL_FRect intersection;
					SDL_IntersectFRect(&blockRect, &player.hitbox, &intersection);

					if (vertical) {
						player.velocity.y = 0.0;
						if (player.velocity.y > 0.0) {
							player.hitbox.y -= intersection.y;
						}
						else {
							player.hitbox.y += intersection.y;
						}
					}
					else {
						player.velocity.x = 0.0;
						if (player.velocity.x > 0.0) {
							player.hitbox.x -= intersection.x;
						}
						else {
							player.hitbox.x += intersection.x;
						}
					}
					
				}
			}
		}
	}

	override void Update(Entity entity, World world, double deltaTime) {
		auto player = cast(Player) entity;

		player.velocity.y += 1.0 * deltaTime; // increase by 1 m/s2 every second

		player.hitbox.x += player.velocity.x * deltaTime;
		Collision(player, world, false);

		player.hitbox.y += player.velocity.y * deltaTime;
		Collision(player, world, true);

		if (player.velocity.y > 5.0) {
			player.velocity.y = 5.0;
		}
	}
}
