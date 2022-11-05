
#include "Character.h"
#include "Root/Root.h"

namespace Oak
{
	ENTITYREG(SceneEntity, Character, "Simple", "Character")

	META_DATA_DESC(Character)
		BASE_SCENE_ENTITY_PROP(Character)
		SCENEOBJECT_PROP(Character, camera, "Properties", "camera")
		SCENEOBJECT_PROP(Character, screensRoot, "Properties", "screens root")
	META_DATA_DESC_END()

	void Character::Play()
	{
		ScriptEntity2D::Play();

		animRef = FindChild<AnimGraph2D>();
		controllerRef = FindChild<KinematicCapsule2D>();

		auto& screens = screensRoot->GetChilds();

		for (auto* screen : screens)
		{
			screen->SetVisiblity(false);
		}

		SetActiveScreen(true);
	}

	void Character::SetActiveScreen(bool forward)
	{
		auto& screens = screensRoot->GetChilds();

		if (curScreen != -1)
		{
			screens[curScreen]->SetVisiblity(false);
		}

		if (forward)
		{
			curScreen++;

			if (curScreen >= screens.size())
			{
				curScreen = 0;
			}
		}
		else
		{
			curScreen--;

			if (curScreen < 0)
			{
				curScreen = screens.size() - 1;
			}
		}

		screens[curScreen]->SetVisiblity(true);

		auto pos = screens[curScreen]->GetTransform().position;

		screenOffset = pos.x;

		camera->GetTransform().position = pos + Math::Vector3(128.0f, 96.0f, 0.0f);

		pos = transform.position;
		pos.x = forward ? (screenOffset + 10.0f) : (screenOffset + 256.0f - 10.0f);
		pos.y += 4.0f;

		controllerRef->SetPosition(pos);
	}

	void Character::Update(float dt)
	{
		if (animRef == nullptr || controllerRef == nullptr)
		{
			return;
		}

		Math::Vector2 moveDir = 0.0f;
		float runSpeed = 120.0f;
		const char* anim = "idle";

		if (GetRoot()->GetControls()->DebugKeyPressed("KEY_A", AliasAction::Pressed))
		{
			moveDir.x = -1.0f;
			flipped = true;
		}

		if (GetRoot()->GetControls()->DebugKeyPressed("KEY_D", AliasAction::Pressed))
		{
			moveDir.x = 1.0f;
			flipped = false;
		}

		if (fabs(moveDir.x) > 0.1f)
		{
			animRef->GetTransform().scale = Math::Vector3(moveDir.x, 1.0f, 1.0f);
		}

		moveDir.x *= runSpeed;

		gravity -= dt * 400.0f;

		if (gravity < -150.0f)
		{
			gravity = -150.0f;
		}

		moveDir.y = gravity;

		if (gravity > 0.0f)
		{
			anim = "jump";
		}
		else
		{
			anim = "fall";
		}

		if (gravity < 0.0f && controllerRef->controller->IsColliding(PhysController::CollideDown))
		{
			gravity = 0.0f;

			if (fabs(moveDir.x) > 0.1f)
			{
				anim = "run";
			}
			else
			{
				anim = "idle";
			}

			if (GetRoot()->GetControls()->DebugKeyPressed("KEY_W", AliasAction::JustPressed))
			{
				gravity = 200.0f;
			}
		}

		controllerRef->Move(moveDir);

		if (transform.position.x > screenOffset + 256.0f - 8.0f)
		{
			SetActiveScreen(true);
		}
		else
		if (transform.position.x < screenOffset + 8.0f)
		{
			SetActiveScreen(false);
		}

		animRef->anim.GotoNode(anim, false);
	}
}