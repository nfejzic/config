function set_rectangle_for_streaming
    # 360 - 24px for menu bar
    defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 335
    defaults write com.knollsoft.Rectangle screenEdgeGapBottom -int 0
    defaults write com.knollsoft.Rectangle screenEdgeGapLeft -int 0
    defaults write com.knollsoft.Rectangle screenEdgeGapRight -int 640

    # Restart rectangle
    pkill -x Rectangle
    open /Applications/Rectangle.app
end

function reset_rectangle
    defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 0
    defaults write com.knollsoft.Rectangle screenEdgeGapBottom -int 0
    defaults write com.knollsoft.Rectangle screenEdgeGapLeft -int 0
    defaults write com.knollsoft.Rectangle screenEdgeGapRight -int 0

    # Restart rectangle
    pkill -x Rectangle
    open /Applications/Rectangle.app
end

if not test (uname -s) = "Darwin"
    functions -e set_yabai_for_streaming
end
