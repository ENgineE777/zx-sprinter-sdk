
#pragma once

#include "SceneEntities/2D/ScriptEntity2D.h"
#include "SceneEntities/2D/AnimGraph2D.h"
#include "SceneEntities/2D/Node2D.h"
#include "SceneEntities/2D/Camera2D.h"
#include "SceneEntities/2D/KinematicCapsule2D.h"

namespace Oak
{
	class Character : public ScriptEntity2D
	{
		AnimGraph2D* animRef;
		KinematicCapsule2D* controllerRef;
		float gravity = 0.0f;

		int curScreen = -1;
		float screenOffset = 0.0f;

		SceneEntityRef<Camera2D> camera;
		SceneEntityRef<Node2D> screensRoot;

		bool flipped = false;

	public:

		META_DATA_DECL_BASE(Character)

		void SetActiveScreen(bool forward);

		void Play() override;
		void Update(float dt) override;
	};
}
