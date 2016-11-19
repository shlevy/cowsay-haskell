#include <sys/stat.h>
#include <stdio.h>

constexpr const char *default_cow = R"*($the_cow = <<"EOC";
        $thoughts   ^__^
         $thoughts  ($eyes)\\_______
            (__)\\       )\\/\\
             $tongue ||----w |
                ||     ||
EOC
)*";

int main(int argc, char ** argv) {
  mkdir("cows", 0755);
  auto out = fopen("cows/default.cow", "w");
  fprintf(out, "%s", default_cow);
  fclose(out);
  return 0;
}
