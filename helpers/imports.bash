# shellcheck source=helpers/formatting.bash
source "$base_folder"/helpers/formatting.bash

# shellcheck source=helpers/color.bash
source "$base_folder"/helpers/color.bash

# shellcheck source=hooks/alert.bash
source "$base_folder"/hooks/alert.bash

# shellcheck source=hooks/timer.bash
source "$base_folder"/hooks/timer.bash

# shellcheck source=segments/host.bash
source "$base_folder"/segments/host.bash

# shellcheck source=segments/path.bash
source "$base_folder"/segments/path.bash

# shellcheck source=segments/git.bash
source "$base_folder"/segments/git.bash

# shellcheck source=segments/filler.bash
source "$base_folder"/segments/filler.bash

# shellcheck source=segments/command.bash
source "$base_folder"/segments/command.bash

# shellcheck source=segments/timestamp.bash
source "$base_folder"/segments/timestamp.bash
