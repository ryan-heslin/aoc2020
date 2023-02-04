library(tidyverse)
input <- read_lines("inputs/day21.txt") %>%
    tibble(temp = .) %>%
    separate(temp, into = c("ingredient", "allergy"), sep = "\\s(?=\\()") %>%
    mutate(allergy = str_remove_all(allergy, "\\(contains|,|\\)$") %>%
        str_trim(.)) %>%
    mutate(across(everything(), ~ str_split(.x, "\\s"))) %>%
    mutate(across(everything(), set_names, nm = 1:36)) %>%
    {
        map2_dfr(.$ingredient, .$allergy, ~ expand.grid(ingred = .x, allerg = .y), .id = "grp")
    } %>%
    arrange(grp) %>%
    group_by(grp) %>%
    mutate(contained = n_distinct(allerg)) %>%
    ungroup() %>%
    mutate(across(c(ingred, allerg), as.character))


food_allerg <- input %>%
    group_by(ingred) %>%
    distinct(allerg, .keep_all = TRUE)

single_grps <- input %>%
    filter(contained == 1) %>%
    distinct(grp, allerg)

mult_groups <- anti_join(input, single_grps, by = "grp") %>%
    distinct(grp, allerg)

ingreds <- unique(input$ingred)
grp_allerg <- input %>%
    group_by(grp) %>%
    distinct(allerg, .keep_all = TRUE) %>%
    select(grp, allerg) %>%
    split(.$allerg)

definites <- input %>%
    group_by(ingred, allerg) %>%
    filter(setequal(pluck(grp_allerg, unique(allerg))[["grp"]], grp)) %>%
    distinct(ingred, allerg) %>%
    ungroup()

elims <- setdiff(ingreds, definites$ingred)

ans1 <- input %>%
    distinct(grp, ingred) %>%
    filter(ingred %in% elims) %>%
    nrow()


reduced <- definites
while (n_distinct(reduced$ingred) < nrow(reduced)) {
    solved <- reduced %>%
        group_by(ingred) %>%
        filter(n() == 1)
    reduced <- reduced %>%
        anti_join(solved, by = "allerg") %>%
        add_row(solved)
}

ans2 <- reduced %>%
    arrange(allerg) %>%
    pull(ingred) %>%
    paste(collapse = ", ")
