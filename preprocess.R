library(data.table)

MIN_MEDIAN_TAIL_T0 = 15

filter_reads <- function(dat, min_median_tail_t0=MIN_MEDIAN_TAIL_T0) {
  
  setDT(dat)

  dat[, barcode := as.integer(barcode)]
  
  good_transcripts <- dat[
    barcode == 1 &
      class != "None" &
      TTS_prox == "yes" &
      poly_tail_length > 0,
    .(median_tail_t0 = median(poly_tail_length, na.rm = TRUE)),
    by = alignment_genome
  ][median_tail_t0 >= min_median_tail_t0, alignment_genome]
  
  dat_filtered <- dat[alignment_genome %in% good_transcripts]
  dat_filtered <- dat_filtered[ class != "None" & TTS_prox == "yes"]
  return(dat_filtered)
}


filter_non_increasing <- function(dat) {
  
  reads_medians <- dat[, .(median = median(poly_tail_length)), by = .(alignment_genome, barcode)]

  setorder(reads_medians, alignment_genome, barcode)

  nonincreasing_ids <- reads_medians[, {
    inc_pos <- which(diff(median) > 0)[1]
    if (is.na(inc_pos)) {
      .SD
    } else {
      .SD[1:inc_pos]
    }
  }, by = alignment_genome][, .(alignment_genome, barcode)]

  nonincreasing_reads <- dat[
    nonincreasing_ids,
    on = .(alignment_genome, barcode),
    nomatch = 0
  ]
  
  return(nonincreasing_reads)

}
