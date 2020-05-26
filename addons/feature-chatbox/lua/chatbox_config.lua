-- Title of the chatbox.
-- Here are special titles:
-- %hostname% : Shows the server's name
-- %players% : Shows the player count on the server
-- %uptime% : Uptime of the server
LOUNGE_CHAT.ChatTitle = ""

-- Show the player's avatar when sending a message
LOUNGE_CHAT.ShowPlayerAvatar = false

-- Message display style
-- 0: Default
-- 1: Discord-like (enable ShowPlayerAvatar for better effect)
LOUNGE_CHAT.MessageStyle = 0

-- Name to display when the console sends a message
-- Parsers are allowed.
LOUNGE_CHAT.ConsoleName = "[Сервер] "

-- Whether to use Workshop or the FastDl for the custom content used by the add-on
LOUNGE_CHAT.UseWorkshop = true

/**
* Advanced configuration
* Only modify these if you know what you're doing.
**/

-- How the <timestamp=...> markup should be formatted.
-- See https://msdn.microsoft.com/en-us/library/fe06s4ak.aspx for a list of available mappings
LOUNGE_CHAT.TimestampFormat = "%c"

-- Where downloaded images should be in GMod's data folder.
LOUNGE_CHAT.ImageDownloadFolder = "lounge_chat_downloads"

-- Whether to use UTF-8 mode for character wrapping and parsing.
-- You can set this to false if your server's main language is Roman script only (English, etc)
LOUNGE_CHAT.UseUTF8 = true

-- Maximum messages allowed in the chatbox before deletion of the oldest messages.
LOUNGE_CHAT.MaxMessages = 200

/**
* Style configuration
**/

-- Font to use for normal text throughout the chatbox.
LOUNGE_CHAT.FontName = "Circular Std Medium"

-- Font to use for bold text throughout the chatbox.
LOUNGE_CHAT.FontNameBold = "Circular Std Bold"

-- Color sheet.
LOUNGE_CHAT.Style = {
	header = Color(55, 55, 55, 155),
	bg = Color(25, 25, 25, 155),
	inbg = Color(35, 35, 35, 155),

	close_hover = Color(155, 155, 155),
	hover = Color(255, 255, 255, 10),
	hover2 = Color(255, 255, 255, 5),

	text = Color(233, 233, 233),
	text_down = Color(0, 0, 0),

	url = Color(52, 152, 219),
	url_hover = Color(62, 206, 255),
	timestamp = Color(166, 166, 166),

	menu = Color(155, 155, 155),
}

LOUNGE_CHAT.Anims = {
	FadeInTime = 0.15,
	FadeOutTime = 0.07,
	TextFadeOutTime = 1,
}

-- Size of the <glow> parser.
LOUNGE_CHAT.BlurSize = 2

/**
* Language configuration
**/


LOUNGE_CHAT.Language = {
	players_online = "Игроков онлайн",
	server_uptime = "Онлайн сервера",
	click_to_load_image = "Нажмите для загрузки изображения",
	failed_to_load_image = "Failed to load image",
	click_here_to_view_x_profile = "Нажмите здесь для просмотра профиля %s",

	chat_options = "Настройки чата",
	clear_chat = "Очистить чат",
	reset_position = "Сбросить позицию",
	reset_size = "Сбросить размер",

	chat_parsers = "Парсеры чата",
	usage = "Использование",
	example = "Пример",

	send = "Отправить",
	copy_message = "Скопировать сообщение",
	copy_url = "Скопировать URL",

	-- options
	general = "Основные",
	chat_x = "X позиция",
	chat_y = "Y позиция",
	chat_width = "Ширина чата",
	chat_height = "Высота чата",
	time_before_messages_hide = "Время перед исчезновением сообщения",
	show_timestamps = "Отобразить часовые штампы",
	clear_downloaded_images = "Очистить кеш(папку) изображений (%s)",
	dont_scroll_chat_while_open = "Не проматывать вниз при открытии",

	display = "Отобразить",
	hide_images = "Спрятать изображения",
	hide_avatars = "Скрыть аватары",
	use_rounded_avatars = "Исп. круглые аватары (disable if FPS is low)",
	disable_flashes = "Отключить вспышки",
	no_url_parsing = "Do not parse URLs",
	autoload_external_images = "Auto-load external images",
	hide_options_button = "Hide options button",
}