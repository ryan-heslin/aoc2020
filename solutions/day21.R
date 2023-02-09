raw_input <- readLines("inputs/day21.txt")
allergens <- gsub(".*\\(contains ([^)]+)\\)", "\\1", raw_input) |>
    strsplit(",\\s+")
ingredients <- gsub("\\s\\(.*", "", raw_input) |>
    strsplit("\\s")

combined <- mapply(expand.grid, ingredient = ingredients, allergen = allergens, group = seq_along(allergens), stringsAsFactors = FALSE, SIMPLIFY = FALSE) |>
    lapply(\(x) {
        x$contained <- length(unique(x$allergen))
        x
    }) |>
    do.call(what = rbind)


input <- read_lines("inputs/day21.txt") %>%
    tibble(temp = .) %>%
    separate(temp, into = c("ingredient", "allergy"), sep = "\\s(?=\\()") %>%
    mutate(allergy = str_remove_all(allergy, "\\(contains|,|\\)$") %>%
        str_trim(.)) %>%
    mutate(across(everything(), ~ str_split(.x, "\\s"))) %>%
    # mutate(across(everything(), set_names, nm = 1:36)) %>%
    {
        map2_dfr(.$ingredient, .$allergy, ~ expand.grid(ingred = .x, allerg = .y), .id = "grp")
    } %>%
    arrange(grp) %>%
    group_by(grp) %>%
    mutate(contained = n_distinct(allerg)) %>%
    ungroup() %>%
    mutate(across(c(ingred, allerg), as.character))



ingreds <- unique(input$ingred)
observed_groups <- tapply(combined$group, combined$allergen, unique)
combinations <- interaction(combined$ingredient, combined$allergen, drop = TRUE)

definite <- split(
    combined,
    f = combinations
)

definite <- definite[vapply(definite, \(x){
    setequal(
        x$group,
        observed_groups[[unique(x$allergen)]]
    )
}, FUN.VALUE = logical(1))] |>
    do.call(what = rbind) |>
    subset(subset = TRUE, select = c("ingredient", "allergen")) |>
    unique()

eliminations <- setdiff(unique(combined$ingredient), definite$ingredient)
part1 <- unique(combined[, c("group", "ingredient")]) |>
    subset(
        subset = ingredient %in% eliminations,
        select = "ingredient"
    ) |>
    nrow()
print(part1)

reduced <- definite
while (anyDuplicated(reduced$ingredient)) {
    # browser()
    counts <- table(reduced$ingredient)
    solved <- reduced[counts[reduced$ingredient] == 1, ]
    reduced <- rbind(reduced[!reduced$allergen %in% solved$allergen, ], solved)
}
part2 <-
    reduced[order(reduced$allergen), "ingredient"] |>
    paste(collapse = ", ")
print(part2)
