window.addEventListener('message', function(event) {
    const { active: Active, type: Type, cooldown: Cooldown } = event.data;
    $(".cooldown-text").css("display", "block");
    let color, text;
    if (Type === "cooldown") {
        color = "red";
        text = `${Active.label}: ${Cooldown} <i class="fa-solid fa-stopwatch fa-shake"></i>`;
    } else {
        color = "rgba(0, 0, 0, 0.925)";
        text = "Inactive";
    }

    // Apply styles and update the HTML content
    $(".cooldown-text").css("background-color", color);
    $(".cooldown-text").html(text);
});