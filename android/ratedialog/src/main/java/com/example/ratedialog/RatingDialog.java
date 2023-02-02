package com.example.ratedialog;

import android.animation.Animator;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.view.Window;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.example.moreapp.MoreAppConfig;
import com.example.moreapp.MoreAppUtil;

import static android.content.Context.MODE_PRIVATE;

/**
 * Created by hoangmobi on 8/20/2017.
 */

public class RatingDialog {
    private Context context;
    private Dialog dialog;
    private RelativeLayout main;
    private ImageView btnCacncel, ratingFace;
    private RotationRatingBar rotationratingbar_main;
    private ImageView btnSubmit;
    private ImageView btnMoreApp;
    private LinearLayout lineButton;
    SharedPreferences pre;
    SharedPreferences.Editor edit;
    private boolean isEnable = true;
    private int defRating = 0;
    RatingDialogInterFace mRatingDialogListener;
    private boolean isHasMoreApp = false;

    public RatingDialog(Context ctx) {
        this.isHasMoreApp = isHasMoreApp;
        this.context = ctx;
        pre = ctx.getSharedPreferences("rateData", MODE_PRIVATE);
        edit = pre.edit();
        dialog = new Dialog(context);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialogmain);
        dialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        btnCacncel = (ImageView) dialog.findViewById(R.id.btnCacncel);
        ratingFace = (ImageView) dialog.findViewById(R.id.ratingFace);
        main = (RelativeLayout) dialog.findViewById(R.id.main);
        lineButton = (LinearLayout) dialog.findViewById(R.id.lineButton);
        rotationratingbar_main = (RotationRatingBar) dialog.findViewById(R.id.rotationratingbar_main);
        btnSubmit = (ImageView) dialog.findViewById(R.id.btnSubmit);
        btnMoreApp = (ImageView) dialog.findViewById(R.id.btnMoreApp);
        if (MoreAppConfig.getMoreAppConfigs() == null || MoreAppConfig.getMoreAppConfigs().isEmpty()) {
            btnMoreApp.setImageResource(R.drawable.ic_cancel_dialog);
            btnCacncel.setVisibility(View.GONE);
        }
        else {
            btnMoreApp.setImageResource(R.drawable.ic_play_dialog);
        }
        dialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(DialogInterface dialogInterface) {
                main.setRotation(0);
                main.setAlpha(0);
                main.setScaleY(0);
                main.setScaleX(0);
                main.clearAnimation();
                rotationratingbar_main.setVisibility(View.INVISIBLE);
                if (mRatingDialogListener != null) {
                    mRatingDialogListener.onDismiss();
                }
            }
        });
        btnCacncel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                closeDialog();

            }
        });
        btnMoreApp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                main.animate().scaleY(0).scaleX(0).alpha(0).rotation(-1800).setDuration(600).setListener(new Animator.AnimatorListener() {
                    @Override
                    public void onAnimationStart(Animator animator) {

                    }

                    @Override
                    public void onAnimationEnd(Animator animator) {
                        dialog.dismiss();
                        main.clearAnimation();
                        rotationratingbar_main.setVisibility(View.INVISIBLE);
                        if (MoreAppConfig.getMoreAppConfigs() != null && !MoreAppConfig.getMoreAppConfigs().isEmpty()) {
                            MoreAppUtil moreAppUtil = new MoreAppUtil(rotationratingbar_main.getContext(), new MoreAppUtil.OnClickInstall() {
                                @Override
                                public void onClick(String packageName) {

                                }
                            });
                            moreAppUtil.show();
                        } else {
                            closeDialog();
                        }
                    }

                    @Override
                    public void onAnimationCancel(Animator animator) {

                    }

                    @Override
                    public void onAnimationRepeat(Animator animator) {

                    }
                }).start();
            }
        });

        rotationratingbar_main.setOnRatingChangeListener(new BaseRatingBar.OnRatingChangeListener() {
            @Override
            public void onRatingChange(BaseRatingBar ratingBar, float rating) {
//                if (ratingBar.getRating() < 4.0f) {
//                    setRatingFace(false);
//                } else {
//                    setRatingFace(true);
//                }
                setRatingFace((int) rating);
                if (mRatingDialogListener != null) {
                    mRatingDialogListener.onRatingChanged(rotationratingbar_main.getRating());
                }
            }
        });

        btnSubmit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                main.animate().scaleY(0).scaleX(0).alpha(0).rotation(-1800).setDuration(600).setListener(new Animator.AnimatorListener() {
                    @Override
                    public void onAnimationStart(Animator animator) {

                    }

                    @Override
                    public void onAnimationEnd(Animator animator) {
                        dialog.dismiss();
                        main.clearAnimation();
                        rotationratingbar_main.setVisibility(View.INVISIBLE);
                        if (mRatingDialogListener != null) {
                            mRatingDialogListener.onSubmit(rotationratingbar_main.getRating());
                        }
                    }

                    @Override
                    public void onAnimationCancel(Animator animator) {

                    }

                    @Override
                    public void onAnimationRepeat(Animator animator) {

                    }
                }).start();
            }
        });

    }

    public void showDialog() {
        isEnable = pre.getBoolean("enb", true);
        if (isEnable) {
            if (dialog != null) dialog.dismiss();
            dialog.show();
            rotationratingbar_main.clearAnimation();
            rotationratingbar_main.setRating(defRating);
            lineButton.clearAnimation();
//            lineButton.setRating(defRating);
            setRatingFace(3);
            main.animate().scaleY(1).scaleX(1).rotation(1800).alpha(1).setDuration(600).setListener(new Animator.AnimatorListener() {
                @Override
                public void onAnimationStart(Animator animator) {

                }

                @Override
                public void onAnimationEnd(Animator animator) {
                    main.clearAnimation();
                    rotationratingbar_main.setVisibility(View.VISIBLE);
                    rotationratingbar_main.startAnimation(AnimationUtils.loadAnimation(context, R.anim.bounce_amn));
                    lineButton.setVisibility(View.VISIBLE);
                    lineButton.startAnimation(AnimationUtils.loadAnimation(context, R.anim.bounce_amn));
                }

                @Override
                public void onAnimationCancel(Animator animator) {

                }

                @Override
                public void onAnimationRepeat(Animator animator) {

                }
            }).start();
        }
    }


    public void setEnable(boolean isEnable) {

        edit.putBoolean("enb", isEnable);
        edit.commit();
    }

    public boolean getEnable() {
        return pre.getBoolean("enb", true);
    }

    private void setRatingFace(boolean isTrue) {
        if (isTrue) {
            ratingFace.setImageResource(R.drawable.favorite);
        } else {
            ratingFace.setImageResource(R.drawable.favorite2);
        }

    }

    private void setRatingFace(int index) {
        switch (index) {
            case 1: {
                ratingFace.setImageResource(R.drawable.face1);
                break;
            }
            case 2: {
                ratingFace.setImageResource(R.drawable.face2);
                break;
            }
            case 3: {
                ratingFace.setImageResource(R.drawable.face3);
                break;
            }
            case 4: {
                ratingFace.setImageResource(R.drawable.face4);
                break;
            }
            case 5: {
                ratingFace.setImageResource(R.drawable.face5);
                break;
            }
            default: {

            }
        }
//        if (notify();) {
//            ratingFace.setImageResource(R.drawable.favorite);
//        } else {
//            ratingFace.setImageResource(R.drawable.favorite2);
//        }

    }

    public void closeDialog() {
        main.animate().scaleY(0).scaleX(0).alpha(0).rotation(-1800).setDuration(600).setListener(new Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(Animator animator) {

            }

            @Override
            public void onAnimationEnd(Animator animator) {
                dialog.dismiss();
                main.clearAnimation();
                rotationratingbar_main.setVisibility(View.INVISIBLE);
                lineButton.setVisibility(View.INVISIBLE);
                if (mRatingDialogListener != null) {
                    mRatingDialogListener.onDismiss();
                }
            }

            @Override
            public void onAnimationCancel(Animator animator) {

            }

            @Override
            public void onAnimationRepeat(Animator animator) {

            }
        }).start();
    }

    public void setDefaultRating(int defaultRating) {
        this.defRating = defaultRating;
    }

    public void setRatingDialogListener(RatingDialogInterFace mRatingDialogListener) {
        this.mRatingDialogListener = mRatingDialogListener;
    }

    public interface RatingDialogInterFace {
        void onDismiss();

        void onSubmit(float rating);

        void onRatingChanged(float rating);
    }

}
