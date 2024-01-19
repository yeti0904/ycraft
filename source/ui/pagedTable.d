module ycraft.ui.pagedTable;

import ycraft.app;
import ycraft.util;
import ycraft.video;
import ycraft.types;
import ycraft.uiManager;
import ycraft.ui.button;

class UIPagedTable : UIElement {
	UIButton    pageLeft;
	UIButton    pageRight;
	size_t      page;
	size_t      itemsPerPage;
	UIElement[] elements;

	this(int x, int y, int w, int h, int pitemsPerPage) {
		rect.x       = x;
		rect.y       = y;
		rect.w       = w;
		rect.h       = h;
		itemsPerPage = pitemsPerPage;

		pageLeft         = new UIButton("<", 16, 16);
		pageLeft.rect.x  = 0;
		pageLeft.rect.y  = (rect.h / 2) - 8;
		pageLeft.data    = cast(void*) this;
		pageLeft.onClick = (UIButton button) {
			auto table = cast(UIPagedTable) button.data;
			if (table.page > 0) -- table.page;
		};

		pageRight         = new UIButton(">", 16, 16);
		pageRight.rect.x  = rect.w - 16;
		pageRight.rect.y  = (rect.h / 2) - 8;
		pageRight.data    = cast(void*) this;
		pageRight.onClick = (UIButton button) {
			auto table = cast(UIPagedTable) button.data;
			if (table.page < (table.elements.length / table.itemsPerPage) - 1) {
				++ table.page;
			}
		};
	}

	void AddElement(UIElement element) {
		elements ~= element;

		element.rect.x = rect.x + 16;
		element.rect.y = rect.y;
		element.rect.w = rect.w - 32;
		element.rect.h = cast(int) (rect.h / itemsPerPage);
	}

	override bool HandleEvent(SDL_Event* e) {
		if (pageLeft.HandleEvent(e) || pageRight.HandleEvent(e)) return true;

		size_t pageStart = page * itemsPerPage;
		for (size_t i = pageStart; i < pageStart + itemsPerPage; ++ i) {
			if (i >= elements.length)       return false;
			if (elements[i].HandleEvent(e)) return true;
		}

		return false;
	}

	void RepositionElements() {
		pageLeft.rect.x  = rect.x;
		pageLeft.rect.y  = ((rect.h / 2) - 8) + rect.y;
		pageRight.rect.x = (rect.x + rect.w) - 16;
		pageRight.rect.y = ((rect.h / 2) - 8) + rect.y;

		foreach (i, ref element ; elements) {
			element.rect.x = rect.x + 16;
			element.rect.y =
				cast(int) (rect.y + ((i % itemsPerPage) * (rect.h / itemsPerPage)));
			element.rect.w = rect.w - 32;
			element.rect.h = cast(int) (rect.h / itemsPerPage);
		}
	}

	override void Render(SDL_Texture* uiTexture) {
		pageLeft.Render(uiTexture);
		pageRight.Render(uiTexture);

		size_t pageStart = page * itemsPerPage;
		for (size_t i = pageStart; i < pageStart + itemsPerPage; ++ i) {
			if (i >= elements.length) break;
			elements[i].Render(uiTexture);
		}
	}
}
