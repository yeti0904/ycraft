module ycraft.player;

import std.math;
import std.stdio;
import std.algorithm;
import ycraft.types;
import ycraft.world;
import ycraft.entity;
import ycraft.video;

class Player : Entity {
	bool        touchingGround;
	Vec2!double velocity; // blocks per second

	this() {
		hitbox   = SDL_FRect(0, 0, 0.8, 1.75);
		velocity = Vec2!double(0, 0);
		physics  = new PlayerPhysicsController();
	}
}

class PlayerPhysicsController : PhysicsController {
	private void Collision(Player player, World world, bool vertical) {
		player.hitbox.x = max(0, player.hitbox.x);
		player.hitbox.y = max(0, player.hitbox.y);
		player.hitbox.x = min(
			cast(double) world.size.x - player.hitbox.w, player.hitbox.x
		);
		player.hitbox.y = min(
			cast(double) world.size.y - player.hitbox.h, player.hitbox.y
		);

		auto start = Vec2!int(
			cast(int) floor(player.hitbox.x), cast(int) floor(player.hitbox.y)
		);
		auto end = Vec2!int(
			cast(int) ceil(player.hitbox.x + player.hitbox.w),
			cast(int) ceil(player.hitbox.y + player.hitbox.h)
		);

		player.touchingGround = false;
		
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
						if (player.velocity.y > 0.0) {
							player.hitbox.y       -= intersection.h;
							player.touchingGround  = true;
						}
						else {
							player.hitbox.y += intersection.h;
						}
						player.velocity.y = 0.0;
					}
					else {
						if (player.velocity.x > 0.0) {
							player.hitbox.x -= intersection.w;
						}
						else {
							player.hitbox.x += intersection.w;
						}
						player.velocity.x = 0.0;
					}
					
				}
			}
		}
	}

	override void Update(Entity entity, World world, double deltaTime) {
		auto player = cast(Player) entity;

		player.velocity.y += 18.0 * deltaTime;

		player.hitbox.x += player.velocity.x * deltaTime;
		Collision(player, world, false);

		player.hitbox.y += player.velocity.y * deltaTime;
		Collision(player, world, true);

		if (player.velocity.y > 70.0) {
			player.velocity.y = 70.0;
		}
	}
}
