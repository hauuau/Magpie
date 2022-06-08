#pragma once
#include "pch.h"
#include "winrt/Windows.UI.Xaml.Controls.Primitives.h"
#include "MainPage.g.h"
#include "MicaBrush.h"
#include "Settings.h"


namespace winrt::Magpie::implementation
{
	struct MainPage : MainPageT<MainPage>
	{
		MainPage();

		~MainPage();

		void NavigationView_SelectionChanged(Microsoft::UI::Xaml::Controls::NavigationView const&, Microsoft::UI::Xaml::Controls::NavigationViewSelectionChangedEventArgs const& args);

		Microsoft::UI::Xaml::Controls::NavigationView RootNavigationView();

	private:
		void _UpdateTheme();

		IAsyncAction _Settings_ColorValuesChanged(Windows::UI::ViewManagement::UISettings const&, IInspectable const&);

		Windows::UI::ViewManagement::UISettings _uiSettings;
		event_token _colorChangedToken{};

		Magpie::Settings _settings{ nullptr };
		std::optional<bool> _isDarkTheme;
	};
}

namespace winrt::Magpie::factory_implementation
{
	struct MainPage : MainPageT<MainPage, implementation::MainPage>
	{
	};
}
