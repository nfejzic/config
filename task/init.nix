{
  config,
  pkgs,
  ...
}:
{
  programs.bat = {
    enable = true;
  };

  home = {
    sessionVariables = {
      TASKRC = "${config.xdg.configHome}/task/taskrc";
    };

    packages = with pkgs; [
      taskwarrior3
      taskwarrior-tui
    ];
  };

  xdg.configFile."task/taskrc".text =
    # ini
    ''
      data.location=~/.local/share/task

      # started/WIP tasks pinned to the top, then by urgency so overdue &
      # due-today float up automatically; waiting/someday tasks hidden.
      report.next.filter=status:pending -WAITING
      report.next.sort=start-,urgency-
      report.next.columns=id,start.age,project,due.relative,description
      report.next.labels=ID,Active,Proj,Due,Task
    '';
}
